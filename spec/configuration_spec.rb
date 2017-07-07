require 'spec_helper'

RSpec.describe 'Configuration' do
  let(:correct_hash) do
    {:base_url=>"https://localhost",
     :test_run_id=>"CC-R180",
     :project_id=>"CC",
     :environment=>"",
     :username=>"Test",
     :password=>"Test",
     :auth_type=>:basic,
     :result_formatter_options=>{:run_only_found_tests=>false, :post_results=>false},
     :create_test_formatter_options=>{:update_existing_tests=>true, :test_owner=>"Test", :custom_labels=>["automated"]}}
  end

  it '#to_hash' do
    expect(TMJFormatter.config.to_hash).to eql(correct_hash)
  end
end

