module AbTestStub
  class RequestStub
    attr_reader :cookies, :session

    def initialize(session, cookies)
      @session = session
      @cookies = cookies
    end

    def to_str
      'request example'
    end
  end

  class MockExperiment
    def initialize(alt_name, rp_include = nil)
      @alternative_name = alt_name
      @rp_include = rp_include
    end

    def alternative_name(alt_name_arg)
      @alt_arg_name = alt_name_arg
      @alternative_name
    end

    def rp_include(rp_arg)
      @rp_arg = rp_arg
      @rp_include
    end

    def alternative_name_called_with
      @alt_arg_name
    end

    def rp_include_called_with
      @rp_arg
    end
  end

  class RequestBuilder
    def self.a_request
      RequestBuilder.new
    end

    def with_ab_cookie(experiment_name, alternative)
      @cookie = create_ab_test_cookie(experiment_name, alternative)
      self
    end

    def with_relying_party(relying_party)
      @session = { transaction_simple_id: relying_party }
      self
    end

    def build
      RequestStub.new(@session, @cookie)
    end

  private

    def create_ab_test_cookie(experiment_name, alternative_name = nil)
      {
          'ab_test' =>
              "{\"#{experiment_name}\": \"#{alternative_name}\"}"
      }
    end
  end

  def create_experiment(experiment_name, alternative_name, relyingPartyToInclude = nil)
    experiment = MockExperiment.new(alternative_name, relyingPartyToInclude)
    ab_test_stub = {
        experiment_name => experiment
    }
    stub_const('AB_TESTS', ab_test_stub)

    experiment
  end
end
