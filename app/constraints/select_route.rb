class SelectRoute
  MATCHES = true
  DOES_NOT_MATCH = false

  private_constant :MATCHES
  private_constant :DOES_NOT_MATCH

  def initialize(ab_test, ab_reporter = -> (request) {})
    @ab_test = ab_test
    @ab_reporter = ab_reporter
  end

  def matches?(request)
    if @ab_test.call(request)
      @ab_reporter.call(request)
      MATCHES
    else
      DOES_NOT_MATCH
    end
  end
end
