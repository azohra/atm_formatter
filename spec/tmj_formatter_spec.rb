require 'spec_helper'

RSpec.describe 'ATMFormatter' do
  it 'check version' do |_e|
    expect(ATMFormatter::VERSION).not_to be nil
  end
end
