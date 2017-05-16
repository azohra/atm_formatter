require "spec_helper"

RSpec.describe 'TMJResultFormatter', skip: true do
  it "example", test_id: 'CC-T913', environment: 'stuff' do |e|
    e.step 'check version' do
      expect(TMJFormatter::VERSION).not_to be nil
    end

    e.step 'test' do
    end
  end
end
