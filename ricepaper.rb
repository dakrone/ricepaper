#!/usr/bin/env ruby
#
# CLI interface to adding articles to your instantpaper account
# Also works as a library in a pinch

require 'rubygems'
# For API ease
require 'httparty'
# Parsing command-line options
require 'optparse'

# This class actually does the api posting
class RicePaperAPI
  include HTTParty
  base_uri 'https://www.instapaper.com/api'
end

# Encapsulation class for libraries or command-line use
class RicePaper
  attr_accessor :username, :password
  attr_reader :error

  def initialize(username, password)
    @username = username
    @password = password
    @error = ""
  end

  def add(url=nil, title=nil)
    return if url.nil?
    result = ""
    @error = ""
    begin
      if title.nil?
        result = RicePaperAPI.post('/add', :query => {:username => @username, :password => @password, :url => url, :"auto-title" => 1})
      else
        result = RicePaperAPI.post('/add', :query => {:username => @username, :password => @password, :url => url, :title => title})
      end
    rescue Net::HTTPServerException
      # Convert an exception to (hopefully), a result we can put in 'error'
      e = $!.to_s
      e =~ /^(\d+) /
        result = $1.to_s
    end
    return true if result == "201"
    @error = case result
             when "400" : "Bad Request"
             when "403" : "Invalid username or password"
             when "500" : "The service encountered an error. Please try again later."
             else "An unknown error occured"
    end
    return false
  end
end

# Only run CLI if actually running the script instead of requiring it.
if __FILE__ == $0
  opthash = Hash.new
  options = OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options] \"<url>\" [\"<url>\" \"<url>\" ...]"
    opts.on("-u", "--username [USER]", "Username") do |opt|
      opthash['username'] = opt
    end
    opts.on("-p", "--password [PASS]", "Password") do |opt|
      opthash['password'] = opt
    end
    opts.on("-t", "--title [TITLE]", "Optional title for instantpaper entry") do |opt|
      opthash['title'] = opt
    end
  end

  options.parse!(ARGV)
  if ARGV.size < 1
    puts "I need a url to add to InstantPaper"
  end

  rp = RicePaper.new(opthash['username'],opthash['password'])
  ARGV.each do |url|
    print "Submitting '#{url}'..."
    if opthash['title']
      result = rp.add(url,opthash['title'])
    else
      result = rp.add(url)
    end
    puts result ? "Successful." : "Failed."
    if !result
      puts "Error: #{rp.error}"
    end
  end
end
