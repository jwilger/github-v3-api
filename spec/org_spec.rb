require 'spec_helper'

describe GitHubV3API::Org do
  describe 'attr_readers' do
    it 'should define attr_readers that pull values from the org data' do
      fields = %w(avatar_url billing_email blog collaborators
        company created_at disk_usage email followers following
        html_url id location login name owned_private_repos plan
        private_gists private_repos public_gists public_repos space
        total_private_repos type url)
      fields.each do |f|
        org = GitHubV3API::Org.new_with_all_data(stub('api'), {f.to_s => 'foo'})
        org.methods.should include(f.to_sym)
        org.send(f).should == 'foo'
      end
    end
  end

  describe '#[]' do
    it 'returns the org data for the specified key' do
      api = mock(GitHubV3API::OrgsAPI)
      api.should_receive(:get).with('github') \
        .and_return(GitHubV3API::Org.new(api, 'login' => 'github', 'company' => 'GitHub'))
      org = GitHubV3API::Org.new(api, 'login' => 'github')
      org['company'].should == 'GitHub'
    end

    it 'only fetches the data once' do
      api = mock(GitHubV3API::OrgsAPI)
      api.should_receive(:get).once.with('github') \
        .and_return(GitHubV3API::Org.new(api, 'login' => 'github', 'company' => 'GitHub'))
      org = GitHubV3API::Org.new(api, 'login' => 'github')
      org['login'].should == 'github'
      org['company'].should == 'GitHub'
      org['foo'].should be_nil
    end
  end

  describe '#repos' do
    it 'returns an array of Repo objects that belong to this org' do
      api = mock(GitHubV3API::OrgsAPI)
      api.should_receive(:list_repos).with('github').and_return([:repo1, :repo2])
      org = GitHubV3API::Org.new_with_all_data(api, 'login' => 'github')
      org.repos.should == [:repo1, :repo2]
    end
  end
end
