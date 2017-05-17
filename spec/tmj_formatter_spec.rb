require 'spec_helper'

RSpec.describe 'TMJFormatter' do
  it 'check version' do |e|
    expect(TMJFormatter::VERSION).not_to be nil
  end
end