require 'spec_helper'

describe GitHubV3API::Repo do
  describe 'attr_readers' do
    it 'should define attr_readers that pull values from the repo data' do
      fields = %w(created_at description fork forks has_downloads has_issues
          has_wiki homepage html_url language master_branch name open_issues
          organization owner parent private pushed_at size source url watchers)
      fields.each do |f|
        repo = GitHubV3API::Repo.new_with_all_data(stub('api'), {f.to_s => 'foo'})
        repo.methods.should include(f.to_sym)
        repo.send(f).should == 'foo'
      end
    end
  end

  describe '#[]' do
    it 'returns the repo data for the specified key' do
      api = stub(GitHubV3API::ReposAPI)
      repo = GitHubV3API::Repo \
        .new_with_all_data(api, 'name' => 'hello-world', 'owner' => {'login' => 'octocat'})
      repo['name'].should == 'hello-world'
    end

    it 'only fetches the data once' do
      api = mock(GitHubV3API::ReposAPI)
      api.should_receive(:get).once.with('octocat', 'hello-world') \
        .and_return(GitHubV3API::Repo.new(api, 'name' => 'hello-world', 'owner' => {'login' => 'octocat'}, 'private' => true))
      repo = GitHubV3API::Repo.new(api, 'name' => 'hello-world', 'owner' => {'login' => 'octocat'})
      repo['name'].should == 'hello-world'
      repo['owner'].should == {'login' => 'octocat'}
      repo['private'].should == true
    end
  end

  describe '#owner_login' do
    it 'returns the login name of the repo owner' do
      api = stub(GitHubV3API::ReposAPI)
      repo = GitHubV3API::Repo.new_with_all_data(api, 'owner' => {'login' => 'octocat'})
      repo.owner_login.should == 'octocat'
    end
  end
end
