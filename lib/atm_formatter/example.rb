# TODO: Figure out a better way to patch this
module RSpec
  module Core
    class Example
      def run(example_group_instance, reporter)
        @example_group_instance = example_group_instance
        @reporter = reporter
        RSpec.configuration.configure_example(self, hooks)
        RSpec.current_example = self

        if RSpec.configuration.dry_run?
          @metadata[:step_index] = 0
          @example_group_instance.instance_exec(self, &@example_block)
        end

        start(reporter)
        Pending.mark_pending!(self, pending) if pending?
        begin
          if skipped?
            Pending.mark_pending! self, skip
          elsif !RSpec.configuration.dry_run?
            with_around_and_singleton_context_hooks do
              begin
                run_before_example
                @example_group_instance.instance_exec(self, &@example_block)

                if pending?
                  Pending.mark_fixed! self

                  raise Pending::PendingExampleFixedError,
                        'Expected example to fail since it is pending, but it passed.',
                        [location]
                end
              rescue Pending::SkipDeclaredInExample => _
                # The "=> _" is normally useless but on JRuby it is a workaround
                # for a bug that prevents us from getting backtraces:
                # https://github.com/jruby/jruby/issues/4467
                #
                # no-op, required metadata has already been set by the `skip`
                # method.
              rescue AllExceptionsExcludingDangerousOnesOnRubiesThatAllowIt => e
                set_exception(e)
              ensure
                run_after_example
              end
            end
          end
        rescue Support::AllExceptionsExceptOnesWeMustNotRescue => e
          set_exception(e)
        ensure
          @example_group_instance = nil # if you love something... let it go
        end

        finish(reporter)
      ensure
        execution_result.ensure_timing_set(clock)
        RSpec.current_example = nil
      end
    end
  end
  end
