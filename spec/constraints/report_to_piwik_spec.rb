require 'rails_helper'
require 'spec_helper'
require 'route_matcher'
require 'ab_test_stub'

describe RouteMatcher do
  EXP_NAME = 'app_transparency'.freeze
  ALTERNATIVE = 'variant'.freeze
  ALTERNATIVE_NAME = "#{EXP_NAME}_#{ALTERNATIVE}".freeze

  result_string = nil

  before(:each) do
    result_string = 'not used'
  end

  it 'execute ab_reporter when experiment matches' do
    request = AbTestStub::RequestBuilder
                  .a_request
                  .with_ab_cookie(EXP_NAME, ALTERNATIVE_NAME)
                  .with_relying_party('test-rp')
                  .build

    ab_test_mock = class_double("AbTest").as_stubbed_const
    expect(ab_test_mock).to receive(:report).with(EXP_NAME, ALTERNATIVE_NAME, 'test-rp', request)

    RouteMatcher::ReportToPiwik.call(EXP_NAME, request)
  end
end
