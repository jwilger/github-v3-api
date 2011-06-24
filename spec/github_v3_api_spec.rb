require 'spec_helper'

describe GitHubV3API do
  it 'is initialized with an OAuth2 access token' do
    lambda { GitHubV3API.new('abcde') }.should_not raise_error
  end

  describe '#orgs' do
    it 'returns an instance of GitHubV3API::OrgsAPI' do
      api = GitHubV3API.new('abcde')
      api.orgs.should be_kind_of GitHubV3API::OrgsAPI
    end
  end

  describe '#repos' do
    it 'returns an instance of GitHubV3API::ReposAPI' do
      api = GitHubV3API.new('abcde')
      api.repos.should be_kind_of GitHubV3API::ReposAPI
    end
  end

  describe '#get' do
    it 'does a get request to the specified path at the GitHub API server and adds the access token' do
      RestClient.should_receive(:get) \
        .with('https://api.github.com/some/path', {:accept => :json, :authorization => 'token abcde'}) \
        .and_return('{}')
      api = GitHubV3API.new('abcde')
      api.get('/some/path')
    end

    it 'returns the result of parsing the result body as JSON' do
      RestClient.stub!(:get => "[{\"foo\": \"bar\"}]")
      api = GitHubV3API.new('abcde')
      api.get('/something').should == [{"foo" => "bar"}]
    end
  end
end
