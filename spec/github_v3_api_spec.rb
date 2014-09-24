require 'spec_helper'

describe GitHubV3API do
  let(:auth_token)  { 'abcde' }
  let(:test_header) { {:accept => :json,
                       :authorization => "token #{auth_token}",
                       :user_agent => 'rubygem-github-v3-api'} }

  it 'is initialized with an OAuth2 access token' do
    lambda { GitHubV3API.new(auth_token) }.should_not raise_error
  end

  describe '#orgs' do
    it 'returns an instance of GitHubV3API::OrgsAPI' do
      api = GitHubV3API.new(auth_token)
      api.orgs.should be_kind_of GitHubV3API::OrgsAPI
    end
  end

  describe '#repos' do
    it 'returns an instance of GitHubV3API::ReposAPI' do
      api = GitHubV3API.new(auth_token)
      api.repos.should be_kind_of GitHubV3API::ReposAPI
    end
  end

  describe "#issues" do
    it "returns an instance of GitHubV3API::IssuesAPI" do
      api = GitHubV3API.new(auth_token)
      api.issues.should be_kind_of GitHubV3API::IssuesAPI
    end
  end

  describe '#get' do
    it 'does a get request to the specified path at the GitHub API server and adds the access token' do
      rcs = String.new('[]')
      rcs.stub!(:headers).and_return({})
      RestClient.should_receive(:get) \
        .with('https://api.github.com/some/path', test_header.merge({:params => {}})) \
        .and_return(rcs)
      api = GitHubV3API.new(auth_token)
      api.get('/some/path')
    end

    it 'returns the result of parsing the result body as JSON' do
      rcs = String.new('[{"foo": "bar"}]')
      rcs.stub!(:headers).and_return({})
      RestClient.stub!(:get => rcs)
      api = GitHubV3API.new(auth_token)
      api.get('/something').should == [{"foo" => "bar"}]
    end

    it "follows a pagination link from the http headers" do
      headers_next = { :link => 'Link: <https://api.github.com/some/nextpath>; rel="next", <https://api.github.com/some/lastpath>; rel="last"' }
      headers_last = { :link => 'Link: <https://api.github.com/some/prevpath>; rel="previous", <https://api.github.com/some/lastpath>; rel="last"' }
      rcs_next = String.new('[]')
      rcs_next.stub!(:headers).and_return(headers_next)
      rcs_last = String.new('[]')
      rcs_last.stub!(:headers).and_return(headers_last)

      RestClient.should_receive(:get) \
        .with('https://api.github.com/some/path', test_header.merge({:params => {}})) \
        .and_return(rcs_next)
      RestClient.should_receive(:get) \
        .with('https://api.github.com/some/nextpath', test_header.merge({:params => {}})) \
        .and_return(rcs_last)
      api = GitHubV3API.new(auth_token)
      api.get('/some/path')
    end

    it 'raises GitHubV3API::Unauthorized instead of RestClient::Unauthorized' do
      RestClient.stub!(:get).and_raise(RestClient::Unauthorized)
      api = GitHubV3API.new(auth_token)
      lambda { api.get('/something') }.should raise_error(GitHubV3API::Unauthorized)
    end
  end

  describe "#post" do
    it "does a post request to the specified path at the github server, adds token, and payload as json" do
      data = {:title => 'omgbbq'}
      json = JSON.generate(data)
      RestClient.should_receive(:post) \
        .with('https://api.github.com/some/path', json, test_header) \
        .and_return('{}')
      api = GitHubV3API.new(auth_token)
      api.post('/some/path', data)
    end
  end

  describe "#patch" do
    it "does a post request to the specified path at the github server, adds token, and payload as json" do
      data = {:title => 'omgbbq'}
      json = JSON.generate(data)
      RestClient.should_receive(:post) \
        .with('https://api.github.com/some/path', json, test_header) \
        .and_return('{}')
      api = GitHubV3API.new(auth_token)
      api.patch('/some/path', data)
    end
  end

  describe "#delete" do
    it 'does a delete request to the specified path at the GitHub API server and adds the access token' do
      RestClient.should_receive(:delete) \
        .with('https://api.github.com/some/path',  test_header) \
        .and_return('{}')
      api = GitHubV3API.new(auth_token)
      api.delete('/some/path')
    end
  end
end
