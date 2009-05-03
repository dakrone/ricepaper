#!/usr/bin/env ruby
#
# CLI interface to adding articles to your instantpaper account
# Also works as a library in a pinch

require 'rubygems'
require 'restclient'

# Encapsulation class
class RicePaper
  attr_accessor :username, :password
  attr_reader :error

  def initialize(username, password)
    @username = username
    @password = password
    @error = ""
  end

  def authenticate
    RestClient.post "https://www.instapaper.com/api/authenticate", :username => @username, :password => @password
  rescue RestClient::RequestFailed
    e = $!.to_s
    e =~ /(\d+)/
      result = $1.to_s
    @error = case result
               when "400" : "Bad Request"
               when "403" : "Invalid username or password"
               when "500" : "The service encountered an error. Please try again later."
               else "An unknown error occured"
             end
    return false
  end

  def add(url=nil, title=nil)
    return if url.nil?
    result = ""
    @error = ""
    if title.nil?
      result = RestClient.post "https://www.instapaper.com/api/add", :username => @username,
        :password => @password,
        :url => url,
        :"auto-title" => 1
    else
      result = RestClient.post "https://www.instapaper.com/api/add", :username => @username,
        :password => @password,
        :url => url,
        :title => title
    end
  rescue RestClient::RequestFailed
    # Convert an exception to (hopefully), a result we can put in 'error'
    e = $!.to_s
    e =~ /(\d+)/
      result = $1.to_s
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
  # Parsing command-line options
  require 'optparse'

  opthash = Hash.new
  options = OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options] \"<url>\" [\"<url>\" \"<url>\" ...]"
    opts.on("-u", "--username [USER]", "Username") do |opt|
      opthash['username'] = opt
    end
    opts.on("-p", "--password [PASS]", "Password") do |opt|
      opthash['password'] = opt
    end
    opts.on("-a", "--authenticate", "Only attempt to authenticate to Instapaper") do |opt|
      opthash['authenticate'] = opt
    end
    opts.on("-t", "--title [TITLE]", "Optional title for instantpaper entry") do |opt|
      opthash['title'] = opt
    end
  end

  options.parse!(ARGV)
  rp = RicePaper.new(opthash['username'],opthash['password'])

  if opthash['authenticate']
      print "Authenticating..."
      result = rp.authenticate
      puts result ? "Successful." : "Failed."
      if !result
        puts "Error: #{rp.error}"
      end
      exit(0)
  end

  if ARGV.size < 1
    puts "I need a url to add to InstantPaper"
  end

  ARGV.each do |url|
    if opthash['title']
      print "Submitting '#{url}' with title '#{opthash['title']}'..."
      result = rp.add(url,opthash['title'])
    else
      print "Submitting '#{url}'..."
      result = rp.add(url)
    end
    puts result ? "Successful." : "Failed."
    if !result
      puts "Error: #{rp.error}"
    end
  end
end
