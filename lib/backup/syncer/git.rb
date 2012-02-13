# encoding: utf-8

module Backup
  module Syncer
    class Git < Base

      attr_accessor :username, :host, :protocol, :port, :repo_path, :path

      def initialize(&block)
        load_defaults!

        instance_eval(&block) if block_given?
      end

      def url
        "#{protocol}://#{username}@#{host}:#{port}#{repo_path}"
      end

      def local_repository_exists?
        run "cd #{path} && git rev-parse --git-dir > /dev/null 2>&1"
        return true
      rescue Errors::CLI::SystemCallError
        Logger.message("#{path} is not a repository")
        return false
      end

      def initialize_repository
        Logger.message("Initializing empty repository")
        run "cd #{path} && git clone --bare #{url}"
      end

      def perform!
        Logger.message("#{ self.class } started syncing '#{ url }'.")
        FileUtils.mkdir_p(path)
        if local_repository_exists? 
          Logger.message("Syncing with remote repository")
          run "cd #{path} && git fetch origin"
        else
          initialize_repository
        end
      end
    end
  end
end
