# encoding: utf-8

module Backup
  module Configuration
    module Syncer
      class Git < Base
        class << self
          attr_accessor :protocol, :username, :host, :port, :path, :repo_path
        end
      end
    end
  end
end
