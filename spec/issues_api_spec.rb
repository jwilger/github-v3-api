require 'spec_helper'

describe GitHubV3API::IssuesAPI do
  describe "#list" do
    context "options = nil" do
      it "returns issues for a user" do
        connection = double(GitHubV3API)
        connection.should_receive(:get).with('/issues', {}).and_return([:issue_hash1, :issue_hash2])
        api = GitHubV3API::IssuesAPI.new(connection)
        GitHubV3API::Issue.should_receive(:new).with(api, :issue_hash1).and_return(:issue1)
        GitHubV3API::Issue.should_receive(:new).with(api, :issue_hash2).and_return(:issue2)
        issues = api.list
        issues.should == [:issue1, :issue2]
      end
    end

    context "options = {:user => 'octocat', :repo => 'hello-world'}" do
      it "returns issues for a repo" do
        connection = double(GitHubV3API)
        connection.should_receive(:get).with("/repos/octocat/hello-world/issues", {}).and_return([:issue_hash1, :issue_hash2])
        api = GitHubV3API::IssuesAPI.new(connection)
        GitHubV3API::Issue.should_receive(:new).with(api, :issue_hash1).and_return(:issue1)
        GitHubV3API::Issue.should_receive(:new).with(api, :issue_hash2).and_return(:issue2)
        issues = api.list({:user => 'octocat', :repo => 'hello-world'})
        issues.should == [:issue1, :issue2]
      end
    end
  end

  describe '#get' do
    it 'returns a fully-hydrated Issue object for the specified user, repo, and issue id' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with('/repos/octocat/hello-world/issues/1234', {}).and_return(:issue_hash)
      api = GitHubV3API::IssuesAPI.new(connection)
      GitHubV3API::Issue.should_receive(:new_with_all_data).with(api, :issue_hash).and_return(:issue)
      api.get('octocat', 'hello-world', 1234).should == :issue
    end

    it 'raises GitHubV3API::NotFound instead of a RestClient::ResourceNotFound' do
      connection = double(GitHubV3API)
      connection.should_receive(:get) \
        .and_raise(RestClient::ResourceNotFound)
      api = GitHubV3API::IssuesAPI.new(connection)
      lambda { api.get('octocat', 'hello-world', 4321) }.should raise_error(GitHubV3API::NotFound)
    end
  end

  describe "#create" do
    it 'returns a fully-hydrated Issue object for the specified user, repo, and issue that was created' do
      connection = double(GitHubV3API)
      data = {:title => "omgbbq"}
      connection.should_receive(:post).with('/repos/octocat/hello-world/issues', data).and_return(:issue_hash)
      api = GitHubV3API::IssuesAPI.new(connection)
      GitHubV3API::Issue.should_receive(:new_with_all_data).with(api, :issue_hash).and_return(:issue)
      api.create('octocat', 'hello-world', data).should == :issue
    end

    it "raises GitHubV3API::MissingRequiredData when data[:title] is missing" do
      connection = double(GitHubV3API)
      connection.should_not_receive(:post)
      api = GitHubV3API::IssuesAPI.new(connection)
      lambda { api.create('octocat', 'hello-world', {}) }.should raise_error(GitHubV3API::MissingRequiredData)
    end
  end

  describe "#update" do
    it 'returns a fully-hydrated Issue object for the specified user, repo, and issue that was updated' do
      connection = double(GitHubV3API)
      data = {:body => "lol, wtf"}
      connection.should_receive(:patch).with('/repos/octocat/hello-world/issues/1234', data).and_return(:issue_hash)
      api = GitHubV3API::IssuesAPI.new(connection)
      GitHubV3API::Issue.should_receive(:new_with_all_data).with(api, :issue_hash).and_return(:issue)
      api.update('octocat', 'hello-world', 1234, data).should == :issue
    end
  end
end
