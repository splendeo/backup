# encoding: utf-8

module Backup
  module Configuration
    module Syncer
      module Repositories
        class Base < Syncer::Base
          class << self

            attr_accessor :protocol, :username, :password, :ip, :port, :path

          end
        end
      end
    end
  end
end
