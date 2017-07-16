require 'rails_helper'
require 'spec_helper'
require 'route_matcher'
require 'ab_test_stub'

describe RouteMatcher do
  include AbTestStub

  EXP_NAME = 'app_transparency'.freeze
  VARIANT_ALTERNATIVE = 'variant'.freeze
  NON_EXISTENT_EXPERIMENT = 'non-existant'.freeze
  ALTERNATIVE_NAME = "#{EXP_NAME}_#{VARIANT_ALTERNATIVE}".freeze

  experiment_details = nil

  before(:each) do
    experiment_details = { experiment_name: EXP_NAME, alternative: VARIANT_ALTERNATIVE }
  end

  it 'evaluates true when experiment and alternative both match' do
    experiment_spy = create_experiment(EXP_NAME, ALTERNATIVE_NAME)
    request = AbTestStub::RequestBuilder
                  .a_request
                  .with_ab_cookie(EXP_NAME, ALTERNATIVE_NAME)
                  .build

    alt_name = RouteMatcher::AbTestCookieMatchesExperiment.curry.(experiment_details)

    expect(alt_name.call(request)).to be true
    expect(experiment_spy.alternative_name_called_with).to eq(ALTERNATIVE_NAME)
  end

  it 'evaluates false when alternative does not match' do
    create_experiment(EXP_NAME, 'different alternative')

    request = AbTestStub::RequestBuilder
                  .a_request
                  .with_ab_cookie(EXP_NAME, ALTERNATIVE_NAME)
                  .build

    expect(RouteMatcher::AbTestCookieMatchesExperiment.call(experiment_details, request)).to be false
  end

  it 'evaluates false when experiment name not found in AB test config' do
    create_experiment(EXP_NAME, ALTERNATIVE_NAME)
    request = AbTestStub::RequestBuilder
                  .a_request
                  .with_ab_cookie(EXP_NAME, ALTERNATIVE_NAME)
                  .build

    experiment_details = { experiment_name: NON_EXISTENT_EXPERIMENT, alternative: 'variant' }

    expect(RouteMatcher::AbTestCookieMatchesExperiment.call(experiment_details, request)).to be false
  end
end
