# encoding: utf-8

module Backup
  module Syncer
    module Repositories
      class Base < Syncer::Base

        ##
        #    https://jimmy:password@example.com:80
        # -> [protocol]://[username]:[password][ip]:[port]
        attr_accessor :protocol, :username, :password, :ip, :port

        ##
        # Additional options for the CLI
        attr_accessor :additional_options

        ##
        # repositories is an alias to directories; provided just for clarity
        alias :repositories  :directories
        alias :repositories= :directories=

        ##
        # Instantiates a new Repository Syncer object
        # and sets the default configuration
        def initialize
          load_defaults!

          @path               ||= 'backups'
          @directories          = Array.new
          @additional_options ||= Array.new
        end

        def authority
          "#{protocol}://#{credentials}#{ip}#{prefixed_port}"
        end

        def repository_urls
          repositories.collect{ |repository| "#{authority}#{repository}" }
        end

        private

        def credentials
          "#{username}#{prefixed_password}@" if username
        end

        def prefixed_password
          ":#{password}" if password
        end

        def prefixed_port
          ":#{port}" if port
        end
      end
    end
  end
end
