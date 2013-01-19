# heroku-ping: utility to keep heroku web applications active
# Copyright (c) 2013 Austin Seipp. See license notice in LICENSE.txt.
require 'clockwork'
require 'rest_client'
require 'logger'

## -----------------------------------------------------------------------------
## -- Init ---------------------------------------------------------------------

LOG = Logger.new(STDOUT)

if ENV['PING_URL'] == nil
  LOG.fatal "No PING_URL set. Aborting."
  Kernel.exit -1
end

## -----------------------------------------------------------------------------
## -- Handlers -----------------------------------------------------------------

def ping
  LOG.info "Pinging #{ENV['PING_URL']}..."
  resp = RestClient.get ENV['PING_URL']
  if resp.code == 200
    LOG.info "OK return code"
  else
    LOG.error "INVALID return code (#{resp.code}) - headers: #{resp.headers}"
    LOG.error "Response given from server:\n#{resp}"
  end
end

## -----------------------------------------------------------------------------
## -- Boilerplate --------------------------------------------------------------

module Clockwork
  handler do |j|
    case j
      when 'ping.homepage' then ping
      else raise ArgumentError, 'Invalid argument!'
    end
  end
  every 20.minutes, 'ping.homepage'
  LOG.info "Now pinging #{ENV['PING_URL']} every 20m..."
end
