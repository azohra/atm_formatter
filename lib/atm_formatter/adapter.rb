module ATMFormatter
  module Adaptor
    RSpec::Core::Example.send :include, ATMFormatter::Example
  end
end
