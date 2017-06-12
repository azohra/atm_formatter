require 'spec_helper'

PRECONDITION = 'PROVIDE SOME DATA HERE'.freeze
OBJECTIVE    = 'JUST A TEST'.freeze
RSpec.describe 'Test Case:', folder: '/Test' do
  it 'Test Example From Local', objective: OBJECTIVE, precondition: PRECONDITION, test_id: 'CC-T1613' do |e|
    e.step 'test 1' do
    end

    e.step 'test 2' do
    end
  end
  context 'sdssd' do
    it 'asdasd', test_id: 'CC-T1613' do |e|
      e.step 'test 1' do
      end

      e.step 'test 2' do
      end
    end
  end
end
