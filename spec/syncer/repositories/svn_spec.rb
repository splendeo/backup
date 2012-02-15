# encoding: utf-8

require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Backup::Syncer::Repositories::SVN do

  let(:svn) do
    Backup::Syncer::Repositories::SVN.new do |svn|
      svn.ip        = 'example.com'
      svn.repositories do
        add '/a/repo/trunk'
        add '/another/repo/trunk'
      end
    end
  end

  describe '#initialize' do
    it 'should use default values' do
      svn.protocol                  == 'http'
      svn.path.should               == 'backups'
      svn.repositories.should       == ['/a/repo/trunk', '/another/repo/trunk']
      svn.additional_options.should == []
    end
  end

  it 'should be a subclass of Repositories::Base' do
    Backup::Syncer::Repositories::SVN.superclass.should == Backup::Syncer::Repositories::Base
  end


  describe '#local_repository_exists?' do
    it "returns false when not in a working copy" do
      svn.expects(:run).with('svnadmin verify backups/my_repo').raises(Backup::Errors::CLI::SystemCallError)
      svn.local_repository_exists?("my_repo").should be_false
    end
    it "returns true when inside a working copy" do
      svn.expects(:run).with('svnadmin verify backups/my_repo')
      svn.local_repository_exists?("my_repo").should be_true
    end
  end

  describe '#backup_repository!' do
    context 'when the local repository exists' do
      it 'invokes update_repository only' do
        svn.expects(:local_repository_exists?).with('/my/repo').returns(true)
        svn.expects(:update_repository).with('/my/repo')

        svn.backup_repository!('/my/repo')
      end
    end
    context 'when the local repository does not exist' do
      it 'invokes initialize_repository and then update_repository' do

        svn.expects(:local_repository_exists?).with('/my/repo').returns(false)
        svn.expects(:initialize_repository).with('/my/repo')
        svn.expects(:update_repository).with('/my/repo')

        svn.backup_repository!('/my/repo')
      end
    end
  end

  describe '#initialize_repository' do
    it 'initializes an empty repository' do
      Backup::Logger.expects(:message).with("Initializing empty repository")
      absolute_path = '/home/jimmy/backups/my/repo'

      svn.expects(:repository_absolute_local_path).with('/my/repo').returns(absolute_path)

      svn.expects(:run).with("svnadmin create 'backups/my/repo'")
      svn.expects(:run).with("echo '#!/bin/sh' > 'backups/my/repo/hooks/pre-revprop-change'")
      svn.expects(:run).with("chmod +x 'backups/my/repo/hooks/pre-revprop-change'")
      svn.expects(:run).with("svn init file://#{absolute_path} http://example.com/my/repo")

      svn.initialize_repository('/my/repo')
    end
  end

end
=begin
  it 'should have defined the configuration properly' do
    svn.username.should  == 'jimmy'
    svn.password.should  == 'secret'
    svn.host.should      == 'foo.com'
    svn.repo_path.should == '/my/repo'
    svn.path.should      == '/home/jimmy/backups/my/repo'
  end

  it 'should use the defaults if a particular attribute has not been defined' do
    Backup::Configuration::Syncer::Repositories::SVN.defaults do |svn|
      svn.username  = 'my_default_username'
      svn.password  = 'my_default_password'
      svn.host      = 'my_default_host.com'
      svn.repo_path = '/my/default/repo/path'
      svn.path      = '/home/jimmy/backups'
    end

    svn = Backup::Syncer::SVN.new do |svn|
      svn.password = "my_password"
      svn.protocol = "https"
      svn.port     = "443"
    end

    svn.username.should == 'my_default_username'
    svn.password.should == 'my_password'
    svn.host.should     == 'my_default_host.com'
    svn.repo_path       == '/my/default/repo/path'
    svn.path            == '/home/jimmy/backups'
    svn.protocol.should == 'https'
    svn.port.should     == '443'
  end

  describe '#url' do
    it "gets calculated using protocol, host, port and path" do
      svn.url.should == "http://foo.com:80/my/repo"
    end
  end

  describe '#local_repository_exists?' do
    it "returns false when not in a working copy" do
      svn.stubs(:run).raises(Backup::Errors::CLI::SystemCallError)
      svn.local_repository_exists?.should be_false
    end

    it "returns true when inside a working copy" do
      svn.stubs(:run)
      svn.local_repository_exists?.should be_true
    end
  end


  describe '#perform' do
    before do
      svn.stubs(:run)
    end

    it 'logs and calls svn without initializing the repo, if it already exists' do
      svn.stubs(:local_repository_exists?).returns true
      Backup::Logger.expects(:message).with("Backup::Syncer::SVN started syncing 'http://foo.com:80/my/repo'.")
      FileUtils.expects(:mkdir_p).with(svn.path)
      svn.expects(:run).with("svn sync file:///home/jimmy/backups/my/repo --non-interactive --source-username jimmy --source-password secret")
      svn.expects(:initialize_repository).at_most(0)
      svn.perform!
    end

    it 'initializes the repo if not initialized' do
      svn.stubs(:local_repository_exists?).returns false
      FileUtils.expects(:mkdir_p).with(svn.path)
      svn.expects(:initialize_repository)
      svn.perform!
    end
  end
  
  describe '#options' do
    it 'includes the username and password if specified' do
      svn = Backup::Syncer::SVN.new do |svn|
        svn.username = "jimmy"
        svn.password = "secret"
      end
      svn.options.should == "--source-username jimmy --source-password secret"
    end
    
    it 'is blank if the username and password is blank' do
      svn = Backup::Syncer::SVN.new do |svn|
        svn.username = nil
        svn.password = nil
      end
      svn.options.should == ""
    end
    
  end

=end
