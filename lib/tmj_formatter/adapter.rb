module TMJFormatter
  module Adaptor
    RSpec::Core::Example.send :include, TMJFormatter::Example
  end
end
