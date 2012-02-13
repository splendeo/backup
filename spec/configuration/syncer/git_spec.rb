# encoding: utf-8

require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Backup::Configuration::Syncer::Git do
  before do
    Backup::Configuration::Syncer::Git.defaults do |git|
      git.protocol            = 'http'
      git.username            = 'my_user_name'
      git.host                = 'example.com'
      git.port                = 1234
      git.repo_path           = '/repository.git'
      git.path                = '~/backups/'
    end
  end
  after { Backup::Configuration::Syncer::Git.clear_defaults! }

  it 'should set the default git configuration' do
    git = Backup::Configuration::Syncer::Git
    git.protocol            = 'http'
    git.username            = 'my_user_name'
    git.host                = 'example.com'
    git.port                = 1234
    git.repo_path           = '/repository.git'
    git.path                = '~/backups/'
  end

  describe '#clear_defaults!' do
    it 'should clear all the defaults, resetting them to nil' do
      Backup::Configuration::Syncer::Git.clear_defaults!

      git = Backup::Configuration::Syncer::Git
      git.protocol            = nil
      git.username            = nil
      git.host                = nil
      git.port                = nil
      git.path                = nil
      git.repo_path           = nil
    end
  end
end
