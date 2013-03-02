# heroku-ping: utility to keep heroku web applications active
# Copyright (c) 2013 Austin Seipp. See license notice in LICENSE.txt.
require 'net/http'

require 'clockwork'
require 'logger'

## -----------------------------------------------------------------------------
## -- Init ---------------------------------------------------------------------

LOG = Logger.new(STDOUT)

if ENV['PING_URL'] == nil
  LOG.fatal "No PING_URL set. Aborting."
  Kernel.exit -1
end

if ENV['PING_METHOD'] == nil
  ENV['PING_METHOD'] = 'HEAD'
end

if ENV['PING_INTERVAL'] == nil
  ENV['PING_INTERVAL'] = '1200'
end

## -----------------------------------------------------------------------------
## -- Handlers -----------------------------------------------------------------

def ping
  LOG.info "Pinging #{ENV['PING_URL']}..."
  LOG.info "HTTP method: #{ENV['PING_METHOD'].to_s.upcase}"

  resp = request(ENV['PING_URL'], ENV['PING_METHOD'].downcase.to_sym)
  if resp.code =~ /^[1-3][0-9]{2}$/ # Valid codes [100-399]
    LOG.info "Status code: (#{resp.code})"
  else
    headers = ''
    resp.each_header { | k, v | headers << "\n#{k} = #{v}" }

    LOG.error "Status code: (#{resp.code})"
    LOG.error "Response headers: #{headers}"
    LOG.error "Response body:\n#{resp.body}" unless resp.body.nil?
  end
end

def request(uri, type=:head)
 url = URI.parse(uri)
 url_path = url.path == '' ? '/' : url.path

 Net::HTTP.start(url.host, url.port) do | http |
   case type
   when :head
     http.head(url_path)
   when :get
     http.get(url_path)
   else
     raise ArgumentError, 'Unsupported HTTP method'
   end
 end
end

## -----------------------------------------------------------------------------
## -- Boilerplate --------------------------------------------------------------

module Clockwork
  handler do |j|
    case j
      when 'ping.act' then ping
      else raise ArgumentError, 'Invalid argument!'
    end
  end
  every ENV['PING_INTERVAL'].to_i.seconds, 'ping.act'
  LOG.info \
    "Now pinging #{ENV['PING_URL']} every #{ENV['PING_INTERVAL']} seconds..."
end
