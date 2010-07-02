#!/usr/bin/env ruby
#
# Library for adding URLs to instapaper.
# by Matthew Lee Hinman (http://writequit.org)
#

require 'rubygems'
require 'rest_client'

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
                when "400" then "Bad Request"
                when "403" then "Invalid username of password"
                when "500" then "There was a server error. Please try again later."
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
  # title; if no title is given, auto-title by instapaper
  def add(url, title=nil, description=nil)
    if (description.nil?)
      result = RestClient.post @apiurl + "add",
        :username     => @username,
        :password     => @password,
        :url          => url,
        :title        => title,
        :"auto-title" => title.nil? ? "1" : "0"
    else
      result = RestClient.post @apiurl + "add",
        :username     => @username,
        :password     => @password,
        :url          => url,
        :title        => title,
        :"auto-title" => title.nil? ? "1" : "0",
        :selection    => description
    end
  rescue RestClient::RequestFailed
    handle_error($!)
    return false
  end
end
