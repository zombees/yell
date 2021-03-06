# encoding: utf-8

# Copyright (c) 2011-2013 Rudolf Schmidt
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module Yell #:nodoc:

  # Holds all Yell severities
  Severities = [ 'DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'UNKNOWN' ]

  class << self
    # Creates a new logger instance.
    #
    # Refer to #Yell::Loggger for usage.
    #
    # @return [Yell::Logger] The logger instance
    def new( *args, &block )
      Yell::Logger.new( *args, &block )
    end

    # Shortcut to Yell::Level.new
    #
    # @return [Yell::Level] The level instance
    def level( val = nil )
      Yell::Level.new( val )
    end

    # Shortcut to Yell::Repository[]
    #
    # @return [Yell::Logger] The logger instance
    def []( name )
      Yell::Repository[ name ]
    end

    # Shortcut to Yell::Repository[]=
    #
    # @return [Yell::Logger] The logger instance
    def []=( name, logger )
      Yell::Repository[ name ] = logger
    end

    # Shortcut to Yell::Fomatter.new
    #
    # @return [Yell::Formatter] A Yell::Formatter instance
    def format( pattern, date_pattern = nil )
      Yell::Formatter.new( pattern, date_pattern )
    end

    # Loads a config from a YAML file
    #
    # @return [Yell::Logger] The logger instance
    def load!( file )
      Yell.new Yell::Configuration.load!(file)
    end

    # @private
    def env
      return ENV['YELL_ENV']  if ENV.key? 'YELL_ENV'
      return ENV['RACK_ENV']  if ENV.key? 'RACK_ENV'
      return ENV['RAILS_ENV'] if ENV.key? 'RAILS_ENV'

      if defined?( Rails )
        Rails.env
      else
        'development'
      end
    end

    # @private
    def _deprecate( version, message, options = {} )
      messages = ["Deprecation Warning (since v#{version}): #{message}" ]
      messages << "  before: #{options[:before]}" if options[:before]
      messages << "  after:  #{options[:after]}" if options[:after]

      _warn( *messages )
    end

    # @private
    def _warn( *messages )
      $stderr.puts "[Yell] " + messages.join( "\n" )
    rescue Exception
      # do nothing
    end
  end

end

# classes
require File.dirname(__FILE__) + '/yell/configuration'
require File.dirname(__FILE__) + '/yell/repository'
require File.dirname(__FILE__) + '/yell/event'
require File.dirname(__FILE__) + '/yell/level'
require File.dirname(__FILE__) + '/yell/formatter'
require File.dirname(__FILE__) + '/yell/silencer'
require File.dirname(__FILE__) + '/yell/adapters'
require File.dirname(__FILE__) + '/yell/logger'

# modules
require File.dirname(__FILE__) + '/yell/loggable'

