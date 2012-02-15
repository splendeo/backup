# encoding: utf-8

require File.expand_path('../../../../spec_helper.rb', __FILE__)

describe Backup::Configuration::Syncer::Repositories::SVN do
  it 'should be a subclass of Repositories::Base' do
    svn = Backup::Configuration::Syncer::Repositories::SVN
    svn.superclass.should == Backup::Configuration::Syncer::Repositories::Base
  end
end
