require 'spec_helper'

describe GitHubV3API::UsersAPI do
  describe '#current' do
    it 'returns the user data for the authenticated user' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with('/user').and_return(:user_hash1)
      api = GitHubV3API::UsersAPI.new(connection)
      GitHubV3API::User.should_receive(:new).with(api, :user_hash1).and_return(:user1)
      user = api.current
      user.should == :user1
    end
  end

  describe '#get' do
    it 'returns a fully-hydrated User object for the specified user login' do
      connection = double(GitHubV3API)
      connection.should_receive(:get).with('/users/octocat').and_return(:user_hash)
      api = GitHubV3API::UsersAPI.new(connection)
      GitHubV3API::User.should_receive(:new_with_all_data).with(api, :user_hash).and_return(:user)
      api.get('octocat').should == :user
    end
  end

end
