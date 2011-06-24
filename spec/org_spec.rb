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
        org = GitHubV3API::Org.new(stub('api'), f.to_s => 'foo')
        org.methods.should include(f)
        org.send(f).should == 'foo'
      end
    end
  end

  describe '#[]' do
    context 'when there is a value for the key' do
      it 'returns the value for the key' do
        api = stub(GitHubV3API::OrgsAPI)
        org = GitHubV3API::Org.new(api, 'login' => 'octocat')
        org['login'].should == 'octocat'
      end
    end

    context 'when there is not a value for the key' do
      it 'should fetch the full data for the org' do
        api = mock(GitHubV3API::OrgsAPI)
        api.should_receive(:get).with('github') \
          .and_return(GitHubV3API::Org.new(api, 'login' => 'github', 'company' => 'GitHub'))
        org = GitHubV3API::Org.new(api, 'login' => 'github')
        org['company'].should == 'GitHub'
      end

      it 'should only attempt to fetch the data once' do
        api = mock(GitHubV3API::OrgsAPI)
        api.should_receive(:get).once.with('github') \
          .and_return(GitHubV3API::Org.new(api, 'login' => 'github', 'company' => 'GitHub'))
        org = GitHubV3API::Org.new(api, 'login' => 'github')
        org['foo'].should be_nil
        org['foo'].should be_nil
      end
    end
  end
end
