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
  RP_SIMPLE_ID = 'a_simple_id'.freeze

  experiment_details = nil

  before(:each) do
    experiment_details = { experiment_name: EXP_NAME, alternative: VARIANT_ALTERNATIVE }
  end

  it 'evaluates true when experiment and relying party match' do
    experiment_spy = create_experiment(EXP_NAME, ALTERNATIVE_NAME, RP_SIMPLE_ID)
    request = AbTestStub::RequestBuilder
                  .a_request
                  .with_ab_cookie(EXP_NAME, ALTERNATIVE_NAME)
                  .with_relying_party(RP_SIMPLE_ID)
                  .build

    expect(RouteMatcher::AbTestMatchesRelyingParty.call(experiment_details, request)).to be true
    expect(experiment_spy.rp_include_called_with).to eq('variant')
  end

  it 'evaluates false when experiment name not found in AB test config' do
    request = AbTestStub::RequestBuilder
                  .a_request
                  .with_ab_cookie(EXP_NAME, ALTERNATIVE_NAME)
                  .with_relying_party(RP_SIMPLE_ID)
                  .build

    expect(RouteMatcher::AbTestMatchesRelyingParty.call({ experiment_name: NON_EXISTENT_EXPERIMENT }, request)).to be false
  end

  it 'evaluates false when relying party does not match' do
    create_experiment(EXP_NAME, ALTERNATIVE_NAME, RP_SIMPLE_ID)
    request = AbTestStub::RequestBuilder
                  .a_request
                  .with_ab_cookie(EXP_NAME, ALTERNATIVE_NAME)
                  .with_relying_party('non-existent-rp')
                  .build

    expect(RouteMatcher::AbTestMatchesRelyingParty.call(experiment_details, request)).to be false
  end
end
