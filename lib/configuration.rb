module ATMFormatter
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :base_url, :test_run_id, :environment, :username, :password,
                  :project_id, :auth_type, :result_formatter_options, :create_test_formatter_options

    def initialize
      @base_url    = nil
      @test_run_id = nil
      @project_id  = nil
      @environment = nil
      @username    = nil
      @password    = nil
      @auth_type   = nil
      @result_formatter_options      = nil
      @create_test_formatter_options = nil
    end

    def to_hash
      hash = {}
      instance_variables.each { |var| hash[var.to_s.delete('@').to_sym] = instance_variable_get(var) }
      hash
    end
  end
end
