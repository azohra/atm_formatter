module TMJFormatter
  module Example
    def step(step, _options = {}, &block)
      @metadata[:steps] = [] if @metadata[:steps].nil?
      begin
        yield block
        @metadata[:steps].push(step_name: step, index: @metadata[:step_index], status: 'Pass')
      rescue Exception => e
        @metadata[:steps].push(step_name: step, index: @metadata[:step_index], status: 'Fail', comment: process_exception(e))
        raise
      ensure
        @metadata[:step_index] += 1 if @metadata.key?(:step_index)
      end
    end

    private

    def process_exception(exception)
      exception.is_a?(RSpec::Expectations::MultipleExpectationsNotMetError) ? format_exception(exception) : exception
    end

    def format_exception(exception)
      exception.failures.join('<br />').gsub("\n", '<br />')
    end
  end
end