require 'spec_helper'

describe GitHubV3API::ReposAPI do
  describe '#list' do
    it 'returns the public and private repos for the authenticated user' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with('/user/repos').and_return([:repo_hash1, :repo_hash2])
      api = GitHubV3API::ReposAPI.new(connection)
      GitHubV3API::Repo.should_receive(:new).with(api, :repo_hash1).and_return(:repo1)
      GitHubV3API::Repo.should_receive(:new).with(api, :repo_hash2).and_return(:repo2)
      repos = api.list
      repos.should == [:repo1, :repo2]
    end
  end

  describe '#get' do
    it 'returns a fully-hydrated Repo object for the specified user and repo name' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with('/repos/octocat/hello-world').and_return(:repo_hash)
      api = GitHubV3API::ReposAPI.new(connection)
      GitHubV3API::Repo.should_receive(:new_with_all_data).with(api, :repo_hash).and_return(:repo)
      api.get('octocat', 'hello-world').should == :repo
    end

    it 'raises GitHubV3API::NotFound instead of a RestClient::ResourceNotFound' do
      connection = double(GitHubV3API)
      connection.should_receive(:get) \
        .and_raise(RestClient::ResourceNotFound)
      api = GitHubV3API::ReposAPI.new(connection)
      lambda { api.get('octocat', 'hello-world') }.should raise_error(GitHubV3API::NotFound)
    end
  end

  describe "#list_collaborators" do
    it 'returns a list of Users who are collaborating on the specified repo' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with(
        '/repos/octocat/hello-world/collaborators').and_return([:user_hash1, :user_hash2])
      connection.should_receive(:users).twice.and_return(:users_api)
      api = GitHubV3API::ReposAPI.new(connection)

      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash1).and_return(:user1)
      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash2).and_return(:user2)

      collaborators = api.list_collaborators('octocat', 'hello-world')
      collaborators.should == [:user1, :user2]
    end
  end

  describe "#list_watchers" do
    it 'returns a list of Users who are watching the specified repo' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with(
        '/repos/octocat/hello-world/watchers').and_return([:user_hash1, :user_hash2])
      connection.should_receive(:users).twice.and_return(:users_api)
      api = GitHubV3API::ReposAPI.new(connection)

      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash1).and_return(:user1)
      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash2).and_return(:user2)

      watchers = api.list_watchers('octocat', 'hello-world')
      watchers.should == [:user1, :user2]
    end
  end

  describe "#list_forks" do
    it 'returns a list of Repos which were forked from the specified repo' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with(
        '/repos/octocat/hello-world/forks').and_return([:repo_hash1, :repo_hash2])
      api = GitHubV3API::ReposAPI.new(connection)

      GitHubV3API::Repo.should_receive(:new).with(api, :repo_hash1).and_return(:fork1)
      GitHubV3API::Repo.should_receive(:new).with(api, :repo_hash2).and_return(:fork2)

      forks = api.list_forks('octocat', 'hello-world')
      forks.should == [:fork1, :fork2]
    end
  end

end
