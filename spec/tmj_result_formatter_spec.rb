require 'spec_helper'

RSpec.describe 'ATMResultFormatter', skip: true do
  it 'example', test_id: 'CC-T913', environment: 'stuff' do |e|
    e.step 'check version' do
      expect(ATMFormatter::VERSION).not_to be nil
    end

    e.step 'test' do
    end
  end
end
