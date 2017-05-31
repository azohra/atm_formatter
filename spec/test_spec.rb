require "spec_helper"

PRECONDITION = 'PROVIDE SOME DATA HERE'
OBJECTIVE    = 'JUST A TEST'
RSpec.describe 'Test Case:', folder: '/Test' do
  it 'Test Example From Local', objective: OBJECTIVE, precondition: PRECONDITION, test_id: 'CC-T1613' do |e|
    e.step 'test 1' do
    end

    e.step 'test 2' do
    end
  end
end

