# heroku-ping: utility to keep heroku web applications active
# Copyright (c) 2013 Austin Seipp. See license notice in LICENSE.txt.

require 'net/http'
require 'net/https'
require 'clockwork'
require 'logger'

## -----------------------------------------------------------------------------
## -- Init ---------------------------------------------------------------------

LOG = Logger.new(STDOUT)

if ENV['PING_URL'].nil?
  LOG.fatal "No PING_URL set. Aborting."
  Kernel.exit(-1)
end

# Default variable set-up
ENV['PING_METHOD'] = 'HEAD' if ENV['PING_METHOD'].nil?
ENV['PING_INTERVAL'] = '1200' if ENV['PING_INTERVAL'].nil?
ENV['PING_VERIFY_SSL'] = '0' if ENV['PING_VERIFY_SSL'].nil?

## -----------------------------------------------------------------------------
## -- Handlers -----------------------------------------------------------------

def ping_sites
  ENV['PING_URL'].split(',').each { | url | ping(url) }
end

def ping(url)
  LOG.info "Pinging #{url}..."
  LOG.info "HTTP method: #{ENV['PING_METHOD'].to_s.upcase}"

  resp = request(url, ENV['PING_METHOD'].downcase.to_sym)
  if resp.nil?
    LOG.error "Ping failed"
  elsif resp.code =~ /^[1-3][0-9]{2}$/ # Valid codes [100-399]
    LOG.info "Status code: (#{resp.code})"
  else
    headers = ''
    resp.each_header { | k, v | headers << "\n#{k} = #{v}" }

    LOG.error "Status code: (#{resp.code})"
    LOG.error "Response headers:#{headers}"
    LOG.error "Response body:\n#{resp.body}" unless resp.body.nil?
  end
end

def request(uri, type=:head)
 url = URI.parse(uri)
 url_path = url.path.empty? ? '/' : url.path

 http = Net::HTTP.new(url.host, url.port)

 handle_ssl(http, uri)
 send_request(http, type, url_path)
rescue StandardError => e
 LOG.error "Encountered (#{e.class.name}) exception"
 LOG.error "Exception message: (#{e.message})"

 nil
end

def handle_ssl(http, uri)
  if uri[/^https/]
    http.use_ssl = true
    unless ENV['PING_VERIFY_SSL'] == '1'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end
end

def send_request(http, type, url_path)
  case type
  when :head
    http.head(url_path)
  when :get
    http.get(url_path)
  else
    raise ArgumentError, 'Unsupported HTTP method'
  end
end

## -----------------------------------------------------------------------------
## -- Boilerplate --------------------------------------------------------------

module Clockwork
  handler do |j|
    case j
      when 'ping.act' then ping_sites
      else raise ArgumentError, 'Invalid argument!'
    end
  end
  every ENV['PING_INTERVAL'].to_i.seconds, 'ping.act'
  LOG.info \
    "Now pinging #{ENV['PING_URL']} every #{ENV['PING_INTERVAL']} seconds..."
end
