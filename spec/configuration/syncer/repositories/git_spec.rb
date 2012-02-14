
# encoding: utf-8

require File.expand_path('../../../../spec_helper.rb', __FILE__)

describe Backup::Configuration::Syncer::Repositories::Git do
  it 'should be a subclass of Repositories::Base' do
    git = Backup::Configuration::Syncer::Repositories::Git
    git.superclass.should == Backup::Configuration::Syncer::Repositories::Base
  end
end
