require 'spec_helper'

describe GitHubV3API::ReposAPI do
  describe '#list' do
    it 'returns the public and private repos for the authenticated user' do
      connection = mock(GitHubV3API)
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
      connection = mock(GitHubV3API)
      connection.should_receive(:get).with('/repos/octocat/hello-world').and_return(:repo_hash)
      api = GitHubV3API::ReposAPI.new(connection)
      GitHubV3API::Repo.should_receive(:new_with_all_data).with(api, :repo_hash).and_return(:repo)
      api.get('octocat', 'hello-world').should == :repo
    end
  end
end
