require 'spec_helper'

describe GitHubV3API::User do
  describe 'attr_readers' do
    it 'should define attr_readers that pull values from the user data' do
      fields = %w(login id avatar_url gravatar_id url name company blog location 
                  email hireable bio public_repos public_gists followers following 
                  html_url created_at type total_private_repos owned_private_repos 
                  private_gists disk_usage collaborators)
      fields.each do |f|
        user = GitHubV3API::User.new_with_all_data(double('api'), {f.to_s => 'foo'})
        user.methods.should include(f.to_sym)
        user.send(f).should == 'foo'
      end
    end
  end

  describe '#[]' do
    it 'returns the user data for the specified key' do
      api = double(GitHubV3API::UsersAPI)
      api.should_receive(:get).with('github') \
        .and_return(GitHubV3API::User.new(api, 'login' => 'github', 'name' => 'GitHub'))
      user = GitHubV3API::User.new(api, 'login' => 'github')
      user['name'].should == 'GitHub'
    end

    it 'only fetches the data once' do
      api = double(GitHubV3API::UsersAPI)
      api.should_receive(:get).once.with('github') \
        .and_return(GitHubV3API::User.new(api, 'login' => 'github', 'name' => 'GitHub'))
      user = GitHubV3API::User.new(api, 'login' => 'github')
      user['login'].should == 'github'
      user['name'].should == 'GitHub'
      user['foo'].should be_nil
    end
  end

end
