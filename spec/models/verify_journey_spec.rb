require 'spec_helper'
require 'verify_journey'

RSpec.describe VerifyJourney do
  let(:session) {
    {
      'verify_session_id' => session_id
    }
  }
  let(:session_proxy) { double(:session_proxy) }
  let(:rp_display_repository) { double(:rp_display_repository) }
  let(:session_id) { double(:session_id) }
  subject { VerifyJourney.new(session, session_proxy, rp_display_repository) }
  describe "#identity_providers" do
    let(:idp_factory) { double(:identity_provider_factory) }
    let(:expected_identity_providers) { [idp_one, idp_two] }
    let(:idp_one) { double(:idp_one) }
    let(:idp_two) { double(:idp_two) }

    before(:each) do
      stub_const("IdentityProvider", idp_factory)
    end

    it 'will ask session proxy for the identity providers if none in session' do
      proxy_idp_one = double(:proxy_idp_one)
      proxy_idp_two = double(:proxy_idp_two)
      identity_providers_from_proxy = [proxy_idp_one, proxy_idp_two]
      expect(session_proxy).to receive(:identity_providers).with(session_id).and_return identity_providers_from_proxy
      expect(idp_factory).to receive(:from_session).with(proxy_idp_one).and_return idp_one
      expect(idp_factory).to receive(:from_session).with(proxy_idp_two).and_return idp_two
      expect(subject.identity_providers).to eql expected_identity_providers
    end

    it 'will not ask session proxy for the identity providers if some in session' do
      session_idp_one = double(:session_idp_one)
      session_idp_two = double(:session_idp_two)
      session[:identity_providers] = [session_idp_one, session_idp_two]
      expect(session_proxy).to_not receive(:identity_providers)
      expect(idp_factory).to receive(:from_session).with(session_idp_one).and_return idp_one
      expect(idp_factory).to receive(:from_session).with(session_idp_two).and_return idp_two
      expect(subject.identity_providers).to eql expected_identity_providers
    end
  end

  describe "#session_id" do
    it 'is value of verify_session_id in the session' do
      expect(subject.session_id).to eql session_id
    end
  end

  describe "#transaction_simple_id" do
    it 'is the value of :transaction_simple_id in the session' do
      simple_id = double(:simple_id)
      session[:transaction_simple_id] = simple_id
      expect(subject.transaction_simple_id).to eql simple_id
    end
  end

  describe "#transaction" do
    it 'uses the value of the simple id to retrive RP display data from a repository' do
      simple_id = double(:simple_id)
      session[:transaction_simple_id] = simple_id
      expected_display_data = double(:rp_display_data)
      expect(rp_display_repository).to receive(:fetch).with(simple_id).and_return(expected_display_data)
      expect(subject.transaction).to eql expected_display_data
    end

    it 'will the cache the value after the first retrieval' do
      simple_id = double(:simple_id)
      session[:transaction_simple_id] = simple_id
      expected_display_data = double(:rp_display_data)
      expect(rp_display_repository).to receive(:fetch).with(simple_id).and_return(expected_display_data).once
      expect(subject.transaction).to eql expected_display_data
      expect(subject.transaction).to eql expected_display_data
    end
  end

  describe '#select_idp' do
    it 'stores the selected idp in the session' do
      idp = double(:idp)
      subject.select_idp(idp)
      expect(session[:selected_idp]).to eql idp
    end
  end

  describe '#selected_idp' do
    let(:idp) { double(:new_idp) }
    let(:idp_in_session) { double(:idp_in_session) }
    let(:idp_factory) { double(:idp_factory) }
    before(:each) do
      stub_const("IdentityProvider", idp_factory)
      session[:selected_idp] = idp_in_session
    end
    it 'returns the selected idp from the session' do
      expect(idp_factory).to receive(:from_session).with(idp_in_session).and_return(idp).once
      expect(subject.selected_idp).to eql idp
    end

    it 'returns cache the result of reading the session' do
      expect(idp_factory).to receive(:from_session).with(idp_in_session).and_return(idp).once
      expect(subject.selected_idp).to eql idp
      expect(subject.selected_idp).to eql idp
    end

    it 'will override the cache if you select a new idp' do
      expect(idp_factory).to receive(:from_session).with(idp_in_session).and_return(idp).once
      expect(subject.selected_idp).to eql idp
      new_idp = double(:new_idp)
      subject.select_idp(new_idp)
      expect(subject.selected_idp).to eql new_idp
    end
  end

  describe '#confirm_sign_in' do
    it 'instructs the session proxy to select the given idp' do
      idp = double(:idp)
      entity_id = double(:entity_id)
      expect(idp).to receive(:entity_id).and_return entity_id
      expect(session_proxy).to receive(:select_idp).with(session_id, entity_id, false)
      subject.confirm_sign_in(idp)
    end
  end

  describe '#confirm_registration' do
    it 'instructs the session proxy to select the given idp' do
      idp = double(:idp)
      entity_id = double(:entity_id)
      expect(idp).to receive(:entity_id).and_return entity_id
      expect(session_proxy).to receive(:select_idp).with(session_id, entity_id, true)
      subject.confirm_registration(idp)
    end
  end

  describe '#idp_authn_request' do
    it 'instructs the session proxy to produce a AuthnRequest for idp' do
      expect(session_proxy).to receive(:idp_authn_request).with(session_id).and_return :foo
      expect(subject.idp_authn_request).to eql :foo
    end
  end

  describe '#selected_answer_store' do
    it 'returns a selected answer store built from the session' do
      factory = double(:selected_answer_store_factory)
      stub_const("SelectedAnswerStore", factory)
      selected_answer_store = double(:selected_answer_store)
      expect(factory).to receive(:new).with(session).and_return selected_answer_store
      expect(subject.selected_answer_store).to eql selected_answer_store
    end
  end

  describe '#selected_evidence' do
    it 'returns the selected evidence found in the selected answer store' do
      factory = double(:selected_answer_store_factory)
      stub_const("SelectedAnswerStore", factory)
      selected_answer_store = double(:selected_answer_store)
      expect(factory).to receive(:new).with(session).and_return selected_answer_store
      selected_evidence = double(:selected_evidence)
      expect(selected_answer_store).to receive(:selected_evidence).and_return selected_evidence
      expect(subject.selected_evidence).to eql selected_evidence
    end
  end
end
