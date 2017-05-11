require "spec_helper"

RSpec.describe 'TMJResultFormatter' do
  it "example", test_id: 'CC-T913s' do |e|
    pending('message')
    e.step 'check version' do
      expect(TMJFormatter::VERSION).not_to be nil
    end

    e.step 'test' do
    end
  end
end
