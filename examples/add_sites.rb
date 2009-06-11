#!/usr/bin/env ruby
# 
# Add sites to Instapaper using Ricepaper
#

require 'ricepaper'

rp = RicePaper.new("username", "password")

sites = [
  "http://google.com",
  "http://ruby-lang.org",
  "http://instapaper.com"
]

sites.each { |site|
  puts "Added #{site}." if rp.add(site)
}
