# encoding: utf-8
require File.expand_path('../../spec_helper.rb', __FILE__)

describe Backup::Syncer::Git do

  let(:git) do
    Backup::Syncer::Git.new do |git|
      git.username  = 'username'
      git.password  = 'secret'
      git.host      = 'example.com'
      git.protocol  = 'git'
      git.port      = 9418
      git.repo_path = '/my/repo.git'
      git.path      = '~/backups/my/repo'
    end
  end

  before do
    Backup::Configuration::Syncer::Git.clear_defaults!

  end

  it "should have defined the configuration properly" do
    git.username.should  == 'username'
    git.password.should  == 'secret'
    git.host.should      == 'example.com'
    git.protocol.should  == 'git'
    git.port.should      == 9418
    git.repo_path.should == '/my/repo.git'
    git.path.should      == '~/backups/my/repo'
  end



  it 'should use the defaults if a particular attribute has not been defined' do
    Backup::Configuration::Syncer::Git.defaults do |git|
      git.username  = 'my_default_username'
      git.password  = 'my_default_password'
      git.host      = 'my_default_host.com'
      git.repo_path = '/my/default/repo/path'
      git.path      = '/home/jimmy/backups'
    end
    git = Backup::Syncer::Git.new do |git|
      git.protocol = "https"
      git.port     = "443"
    end

    git.username.should == 'my_default_username'
    git.password.should == 'my_default_password'
    git.host.should     == 'my_default_host.com'
    git.repo_path       == '/my/default/repo/path'
    git.path            == '/home/jimmy/backups'
    git.protocol.should == 'https'
    git.port.should     == '443'
  end

  describe '#url' do
    it "gets calculated using protocol, host, port and path" do
      git.url.should == "git://username:secret@example.com:9418/my/repo.git"
    end
   
    it "ignores missing port successfully" do
      git.port = nil
      git.url.should == "git://username:secret@example.com/my/repo.git"
    end
   
    it "ignores missing user successfully" do
      git.username = nil
      git.url.should == "git://example.com:9418/my/repo.git"
    end

    it "ignores missing password successfully" do
      git.password = nil
      git.url.should == "git://example.com:9418/my/repo.git"
    end
  end

  describe '#local_repository_exists?' do
    it "returns false when not in a working copy" do
      git.stubs(:run).raises(Backup::Errors::CLI::SystemCallError)
      git.local_repository_exists?.should be_false
    end

    it "returns true when inside a working copy" do
      git.stubs(:run)
      git.local_repository_exists?.should be_true
    end
  end

  describe '#initialize_repo' do
    it 'initializes an empty repo' do
      git.stubs(:run)

      Backup::Logger.expects(:message).with("Initializing empty repository")
      git.expects(:run).with("cd #{git.path} && git clone --bare #{git.url}")

      git.initialize_repository
    end
  end

  describe '#perform' do
    before do
      git.stubs(:run)
    end

    it 'logs and calls git fetch without initializing the repo, if it already exists' do
      git.stubs(:local_repository_exists?).returns true
      Backup::Logger.expects(:message).with("Backup::Syncer::Git started syncing 'git://username:secret@example.com:9418/my/repo.git'.")
      Backup::Logger.expects(:message).with("Syncing with remote repository")
      FileUtils.expects(:mkdir_p).with(git.path)
      git.expects(:run).with("cd ~/backups/my/repo && git fetch origin")
      git.expects(:initialize_repository).at_most(0)
      git.perform!
    end

    it 'initializes the repo if not initialized' do
      git.stubs(:local_repository_exists?).returns false
      FileUtils.expects(:mkdir_p).with(git.path)
      git.expects(:initialize_repository)
      git.perform!
    end
  end
end
