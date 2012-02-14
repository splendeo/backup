# encoding: utf-8

require File.expand_path('../../../../spec_helper.rb', __FILE__)

describe Backup::Configuration::Syncer::Repositories::SVNSync do
  it 'should be a subclass of Repositories::Base' do
    svnsync = Backup::Configuration::Syncer::Repositories::SVNSync
    svnsync.superclass.should == Backup::Configuration::Syncer::Repositories::Base
  end
end


