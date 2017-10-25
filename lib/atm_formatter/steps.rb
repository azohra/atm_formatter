module ATMFormatter
  module Example
    def step(step, _options = {}, &block)
      @metadata[:steps] = [] if @metadata[:steps].nil?
      if RSpec.configuration.dry_run?
        @metadata[:steps].push(step_name: step, index: @metadata[:step_index])
      else
        begin
          yield block
          @metadata[:steps].push(step_name: step, index: @metadata[:step_index], status: 'Pass')
        rescue => e
          @metadata[:steps].push(step_name: step, index: @metadata[:step_index], status: 'Fail', comment: process_exception(e))
          raise
        end
      end
    ensure @metadata[:step_index] += 1 if @metadata.key?(:step_index)
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
