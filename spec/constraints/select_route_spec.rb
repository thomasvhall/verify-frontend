require 'rails_helper'
require 'spec_helper'

describe SelectRoute do
  EXP_NAME = 'app_transparency'.freeze
  ALTERNATIVE_NAME = "#{EXP_NAME}_variant".freeze

  select_route = nil
  ab_reporter = nil
  request = nil

  before(:each) do
  end

  context 'experiment tests' do
    before(:each) do
      request = TestRequest.new
    end

    it 'evaluates true when ab test function returns true' do
      ab_test = -> (_) { true }
      select_route = SelectRoute.new(ab_test)

      expect(select_route.matches?(request)).to be true
    end

    it 'evaluates false when ab test function returns false' do
      ab_test = -> (_) { false }
      select_route = SelectRoute.new(ab_test)

      expect(select_route.matches?(request)).to be false
    end
  end

  context 'reporting' do
    result_string = nil

    before(:each) do
      result_string = 'not used'

      ab_reporter = -> (req) {
        result_string = req.to_str
      }
    end

    it 'execute ab_reporter when experiment matches' do
      select_route = SelectRoute.new(-> (_) { true }, ab_reporter)
      select_route.matches?(request)

      expect(result_string).to eq("request example")
    end

    it 'does not execute ab_reporter when experiment does not match' do
      select_route = SelectRoute.new(-> (_) { false }, ab_reporter)
      select_route.matches?(request)

      expect(result_string).to eq('not used')
    end
  end

private

  class TestRequest
    def to_str
      'request example'
    end
  end
end
