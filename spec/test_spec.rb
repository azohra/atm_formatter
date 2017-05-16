require "spec_helper"

PRECONDITION = 'PROVIDE SOME DATA HERE'

RSpec.describe 'Test Case' do
  it 'Test Example From Local', precondition: PRECONDITION, test_id: 'CC-T1444' do |e|
    e.step 'test' do
    end

    e.step 'test 2' do
    end
  end
end