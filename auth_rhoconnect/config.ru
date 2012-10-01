#!/usr/bin/env ruby
require 'rhoconnect/application/init'

# secret is generated along with the app
Rhoconnect::Server.set     :secret,      '5511aee0fca47e3b0f5b7bf79784cc70bb86607e388511d860a484586091f8a0aed22a6a07d6a5278b92dea9c05f184a5d76d1c3226e430739498af31a670656'

# !!! Add your custom initializers and overrides here !!!
# For example, uncomment the following line to enable Stats
#Rhoconnect::Server.enable  :stats

# Load RhoConnect application
require './application'

# run RhoConnect Application
run Rhoconnect.app