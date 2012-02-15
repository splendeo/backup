# encoding: utf-8

module Backup
  module Syncer
    module Repositories
      class SVN < Base

        def initialize(&block)

          super

          @protocol ||= "http"

          instance_eval(&block) if block_given?
        end

        def local_repository_exists?(repository)
          run "svnadmin verify #{repository_local_path(repository)}"
          return true
        rescue Errors::CLI::SystemCallError
          return false
        end

        def initialize_repository(repository)
          Logger.message("Initializing empty repository")

          local_path = repository_local_path(repository)
          absolute_path = repository_absolute_local_path(repository)
          hook_path = File.join(local_path, 'hooks', 'pre-revprop-change')

          run "svnadmin create '#{local_path}'"
          run "echo '#!/bin/sh' > '#{hook_path}'"
          run "chmod +x '#{hook_path}'"
          run "svn init file://#{absolute_path} #{repository_url(repository)}"
        end 


        def backup_repository!(repository)
          initialize_repository(repository) unless local_repository_exists?(repository)
          update_repository(repository)
        end

=begin
        def initialize_repository
          Logger.message("Initializing empty repository")
          run "svnadmin create '#{path}'"
          hook_path = File.join(path, 'hooks', 'pre-revprop-change')
          run "echo '#!/bin/sh' > '#{hook_path}'"
          run "chmod +x '#{hook_path}'"
          run "svn init file://#{path} #{url} #{options}"
        end

        def perform!
          Logger.message("#{ self.class } started syncing '#{ url }'.")
          FileUtils.mkdir_p(path)
          initialize_repository unless local_repository_exists?
          Logger.message("Syncing with remote repository")
          run "svn sync file://#{path} --non-interactive #{options}"
        end

        def options
          ([remote_repository_username, remote_repository_password]).compact.join("\s")
        end

        def remote_repository_username
          return "--source-username #{username}" if self.username
        end

        def remote_repository_password
          return "--source-password #{password}" if self.password
        end
=end
      end
    end
  end
end
