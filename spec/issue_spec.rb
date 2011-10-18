require 'spec_helper'

describe GitHubV3API::Issue do
  describe 'attr_readers' do
    it 'should define attr_readers that pull values from the issue data' do
      fields = %w(url html_url number state title body user labels assignee
                  milestone comments pull_request closed_at created_at updated_at)
      fields.each do |f|
        repo = GitHubV3API::Issue.new_with_all_data(stub('api'), {f.to_s => 'foo'})
        repo.methods.should include(f.to_sym)
        repo.send(f).should == 'foo'
      end
    end
  end
end
