#!/usr/bin/env ruby
# 
# Test authenticating the user to Instapaper
#

require 'ricepaper'

rp = RicePaper.new("username", "password")

if rp.authenticate
  puts "Authentication successfull."
else
  puts "Authentication failed."
end
