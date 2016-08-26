class VerifyJourney
  def initialize(session, session_proxy, rp_display_repository)
    @session = session
    @session_proxy = session_proxy
    @rp_display_repository = rp_display_repository
  end

  def session_id
    session['verify_session_id']
  end

  def current_identity_providers
    session[:identity_providers] ||= session_proxy.identity_providers(session_id)
    @current_identity_providers ||= session[:identity_providers].map { |obj| IdentityProvider.from_session(obj) }
  end

  alias_method :identity_providers, :current_identity_providers

  def select_idp(identity_provider)
    session[:selected_idp] = identity_provider
    @selected_idp = identity_provider
  end

  def selected_idp
    @selected_idp ||= IdentityProvider.from_session(session[:selected_idp])
  end

  def confirm_sign_in(idp)
    session_proxy.select_idp(session_id, idp.entity_id, false)
  end

  def confirm_registration(idp)
    session_proxy.select_idp(session_id, idp.entity_id, true)
  end

  def idp_authn_request
    IdentityProviderRequest.new(
      session_proxy.idp_authn_request(session_id),
      selected_idp.simple_id,
      selected_answer_store.selected_answers
    )
  end

  def current_transaction
    @current_transaction ||= @rp_display_repository.fetch(current_transaction_simple_id)
  end

  alias_method :transaction, :current_transaction

  def current_transaction_simple_id
    session[:transaction_simple_id]
  end

  alias_method :transaction_simple_id, :current_transaction_simple_id

  def selected_answer_store
    @selected_answer_store ||= SelectedAnswerStore.new(session)
  end

  def selected_evidence
    selected_answer_store.selected_evidence
  end

private

  attr_reader :session
  attr_reader :session_proxy
end
