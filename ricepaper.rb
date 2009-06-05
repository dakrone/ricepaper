#!/usr/bin/env ruby
#
# CLI interface to adding articles to your instantpaper account
# Also works as a library in a pinch

require 'rubygems'
require 'rest_client'
require 'optparse'

# Encapsulation class

class RicePaper

  attr_accessor :username, :password, :apiurl
  attr_reader   :error

  def initialize(username, password, apiurl = "https://www.instapaper.com/api/")
    @username = username
    @password = password
    @apiurl = apiurl
    @error = ""
  end

  # Handle Errors - sets the error code appropriately
  # so that it can be reported
  def handle_error(err)
    result = /(\d+)/.match(err.to_s)[1]
    @error = case result
                when "400" : "Bad Request"
                when "403" : "Invalid username of password"
                when "500" : "There was a server error. Please try again later."
                else "An unknown error occured"
              end
  end

  # Authenticate with instapaper, returning true if auth
  # was successful, false otherwise
  def authenticate
    RestClient.post @apiurl + "authenticate", 
      :username => @username, 
      :password => @password
  rescue RestClient::RequestFailed
    handle_error($!)
    return false
  end

  # Add a url to instapaper, given a url and an optional
  # title; if no title is given, auto-title at instapaper
  def add(url, title=nil)
    result = RestClient.post @apiurl + "add",
      :username     => @username,
      :password     => @password,
      :url          => url,
      :title        => title,
      :"auto-title" => title.nil? ? "1" : "0"
  rescue RestClient::RequestFailed
    handle_error($!)
    return false
  end
end

# Only run CLI if actually running the script instead of requiring it.
if __FILE__ == $0

  opthash = Hash.new
  options = OptionParser.new do |opts|
    opts.banner = %q|Usage: #{$0} [options] "<url>" ["<url>" "<url>" ...]|
    opts.on("-u", "--username [USER]", "Username") { |opt| opthash['username'] = opt }
    opts.on("-p", "--password [PASS]", "Password") { |opt| opthash['password'] = opt }
    opts.on("-a", "--authenticate", "Only attempt to authenticate to Instapaper") { |opt| opthash['authenticate'] = opt }
    opts.on("-t", "--title [TITLE]", "Optional title for instantpaper entry") { |opt| opthash['title'] = opt }
  end

  options.parse!(ARGV)
  rp = RicePaper.new(opthash['username'],opthash['password'])

  if opthash['authenticate']
      print "Authenticating... "
      result = rp.authenticate

      puts result ? "Successful." : "Failed."
      puts "Error: #{rp.error}" unless result
      exit(0)
  end

  if ARGV.size < 1
    puts "I need a url to add to InstantPaper"
  end

  ARGV.each do |url|
    print "Submitting '#{url}' #{opthash['title'].nil? ? "" : "with title '#{opthash['title']}'"} ... "
    result = rp.add(url,opthash['title'])

    puts result ? "Successful." : "Failed."
    puts "Error: #{rp.error}" unless result
  end
end
