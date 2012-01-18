require 'spec_helper'

describe GitHubV3API::OrgsAPI do
  describe '#list' do
    it 'returns the public and private orgs for the authenticated user' do
      connection = mock(GitHubV3API)
      connection.should_receive(:get).with('/user/orgs').and_return([:org_hash1, :org_hash2])
      api = GitHubV3API::OrgsAPI.new(connection)
      GitHubV3API::Org.should_receive(:new).with(api, :org_hash1).and_return(:org1)
      GitHubV3API::Org.should_receive(:new).with(api, :org_hash2).and_return(:org2)
      orgs = api.list
      orgs.should == [:org1, :org2]
    end
  end

  describe '#get' do
    it 'returns a fully-hydrated Org object for the specified org login' do
      connection = mock(GitHubV3API)
      connection.should_receive(:get).with('/orgs/octocat').and_return(:org_hash)
      api = GitHubV3API::OrgsAPI.new(connection)
      GitHubV3API::Org.should_receive(:new_with_all_data).with(api, :org_hash).and_return(:org)
      api.get('octocat').should == :org
    end
  end

  describe '#list_repos' do
    it 'returns the public and private repos for the specified org' do
      connection = mock(GitHubV3API, :repos => :repos_api)
      connection.should_receive(:get) \
        .with('/orgs/github/repos') \
        .and_return([:repo1_hash, :repo2_hash])
      GitHubV3API::Repo.should_receive(:new) \
        .with(:repos_api, :repo1_hash) \
        .and_return(:repo1)
      GitHubV3API::Repo.should_receive(:new) \
        .with(:repos_api, :repo2_hash) \
        .and_return(:repo2)
      api = GitHubV3API::OrgsAPI.new(connection)
      api.list_repos('github').should == [:repo1, :repo2]
    end
  end

  describe '#list_members' do
    it 'returns the list of members for the specified org' do
      connection = mock(GitHubV3API, :users => :users_api)
      connection.should_receive(:get).once.with('/orgs/github/members') \
        .and_return([:user_hash1, :user_hash2])

      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash1) \
        .and_return(:user1)

      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash2) \
        .and_return(:user2)

      api = GitHubV3API::OrgsAPI.new(connection)
      api.list_members('github').should == [:user1, :user2]
    end
  end

  describe '#list_public_members' do
    it 'returns the list of public members for the specified org' do
      connection = mock(GitHubV3API, :users => :users_api)
      connection.should_receive(:get).once.with('/orgs/github/public_members') \
        .and_return([:user_hash1, :user_hash2])

      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash1) \
        .and_return(:user1)

      GitHubV3API::User.should_receive(:new).with(:users_api, :user_hash2) \
        .and_return(:user2)

      api = GitHubV3API::OrgsAPI.new(connection)
      api.list_public_members('github').should == [:user1, :user2]
    end
  end

end
