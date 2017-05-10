require "spec_helper"

RSpec.describe TMJResultFormatter do
  it "example" do |e|
    e.step 'check version' do
      expect(TMJFormatter::VERSION).not_to be nil
    end
  end
end
