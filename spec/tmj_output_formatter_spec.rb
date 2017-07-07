require 'spec_helper'

RSpec.describe TMJOutputFormatter, 'nrf' => true do
  include FormatterSupport

  subject { TMJOutputFormatter.new(StringIO.new) }

  it 'index set to 0 on example start' do
    example = new_example
    subject.example_started(example_started(example))
    expect(example.metadata[:step_index]).to eql(0)
  end

  it '#passed_example' do
    expect(subject.example_passed(example_passed)).to be_nil
  end

  it '#pending_example' do
    expect(subject.example_pending(example_pending)).to be_nil
  end

  it '#failed_example' do
    expect(subject.example_failed(example_failed)).to be_nil
  end
end