require 'rails_helper'
require 'spec_helper'
require 'route_matcher'
require 'ab_test_stub'

describe RouteMatcher do
  include AbTestStub

  EXP_NAME = 'app_transparency'.freeze
  VARIANT_ALTERNATIVE = 'variant'.freeze
  CONTROL_ALTERNATIVE = 'control'.freeze
  NON_EXISTENT_EXPERIMENT = 'non-existant'.freeze
  ALTERNATIVE_NAME = "#{EXP_NAME}_#{VARIANT_ALTERNATIVE}".freeze
  RP_SIMPLE_ID = 'a_simple_id'.freeze

  context 'control route' do
    it 'returns true when request contains control alternative' do
      alternative_name = "proof_of_address_#{CONTROL_ALTERNATIVE}"
      experiment_spy = create_experiment('proof_of_address', alternative_name)
      request = AbTestStub::RequestBuilder
                    .a_request
                    .with_ab_cookie('proof_of_address', alternative_name)
                    .build

      expect(RouteMatcher::ProofOfAddressA.call(request)).to be true
      expect(experiment_spy.alternative_name_called_with).to eq(alternative_name)
    end

    it 'returns true when variant alternative and relying party does not match' do
      alternative_name = "proof_of_address_#{VARIANT_ALTERNATIVE}"
      experiment_spy = create_experiment('proof_of_address', alternative_name, RP_SIMPLE_ID)
      request = AbTestStub::RequestBuilder
                    .a_request
                    .with_ab_cookie('proof_of_address', alternative_name)
                    .with_relying_party('non matching simple id')
                    .build

      expect(RouteMatcher::ProofOfAddressA.call(request)).to be true
      expect(experiment_spy.rp_include_called_with).to eq(VARIANT_ALTERNATIVE)
    end

    it 'returns false when request contains variant alternative and relying party that matches' do
      alternative_name = "proof_of_address_#{VARIANT_ALTERNATIVE}"
      create_experiment('proof_of_address', alternative_name, RP_SIMPLE_ID)
      request = AbTestStub::RequestBuilder
                    .a_request
                    .with_ab_cookie('proof_of_address', alternative_name)
                    .with_relying_party(RP_SIMPLE_ID)
                    .build

      expect(RouteMatcher::ProofOfAddressA.call(request)).to be false
    end
  end

  context 'variant route' do
    it 'returns true when experiment and relying party matches' do
      alternative_name = "proof_of_address_#{VARIANT_ALTERNATIVE}"
      experiment_spy = create_experiment('proof_of_address', alternative_name, RP_SIMPLE_ID)
      request = AbTestStub::RequestBuilder
                    .a_request
                    .with_ab_cookie('proof_of_address', alternative_name)
                    .with_relying_party(RP_SIMPLE_ID)
                    .build

      expect(RouteMatcher::ProofOfAddressB.call(request)).to be true
      expect(experiment_spy.alternative_name_called_with).to eq(alternative_name)
      expect(experiment_spy.rp_include_called_with).to eq(VARIANT_ALTERNATIVE)
    end

    it 'returns false when experiment does not match' do
      alternative_name = 'proof_of_address_variant'
      create_experiment(NON_EXISTENT_EXPERIMENT, alternative_name, RP_SIMPLE_ID)
      request = AbTestStub::RequestBuilder
                    .a_request
                    .with_ab_cookie('proof_of_address', alternative_name)
                    .build

      expect(RouteMatcher::ProofOfAddressB.call(request)).to be false
    end

    it 'returns false when alternative name does not match' do
      alternative_name = 'proof_of_address_variant'
      create_experiment('proof_of_address', 'different alternative')

      request = AbTestStub::RequestBuilder
                    .a_request
                    .with_ab_cookie('proof_of_address', alternative_name)
                    .build

      expect(RouteMatcher::ProofOfAddressB.call(request)).to be false
    end

    it 'returns false when relying party does not match' do
      alternative_name = 'proof_of_address_variant'
      create_experiment('proof_of_address', alternative_name, RP_SIMPLE_ID)
      request = AbTestStub::RequestBuilder
                    .a_request
                    .with_ab_cookie('proof_of_address', alternative_name)
                    .with_relying_party('non matching simple id')
                    .build

      expect(RouteMatcher::ProofOfAddressB.call(request)).to be false
    end
  end
end
