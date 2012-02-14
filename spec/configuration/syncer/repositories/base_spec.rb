# encoding: utf-8

require File.expand_path('../../../../spec_helper.rb', __FILE__)

describe Backup::Configuration::Syncer::Repositories do
  before do
    Backup::Configuration::Syncer::Repositories::Base.defaults do |base|
      base.protocol   = 'http'
      base.username   = 'my_user_name'
      base.password   = 'secret'
      base.ip         = 'example.com'
      base.port       = 1234
      base.path       = '~/backups/'
      # base.directories/repositories # can not have a default value
    end
  end

  after { Backup::Configuration::Syncer::Repositories::Base.clear_defaults! }

  it 'should set the default base configuration' do
    base = Backup::Configuration::Syncer::Repositories::Base
    base.protocol.should == 'http'
    base.username.should == 'my_user_name'
    base.password.should == 'secret'
    base.ip.should       == 'example.com'
    base.port.should     == 1234
    base.path.should     == '~/backups/'
  end

  describe '#clear_defaults!' do
    it 'should clear all the defaults, resetting them to nil' do
      Backup::Configuration::Syncer::Repositories::Base.clear_defaults!

      base = Backup::Configuration::Syncer::Repositories::Base
      base.protocol.should == nil
      base.username.should == nil
      base.password.should == nil
      base.ip.should       == nil
      base.port.should     == nil
      base.path.should     == nil
    end
  end

end
