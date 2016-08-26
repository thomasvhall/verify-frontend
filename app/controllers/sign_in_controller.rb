class SignInController < ApplicationController
  def index
    @identity_providers = IDENTITY_PROVIDER_DISPLAY_DECORATOR.decorate_collection(
      journey.identity_providers
    )

    @unavailable_identity_providers = IDENTITY_PROVIDER_DISPLAY_DECORATOR.decorate_collection(
      unavailable_idps.map { |simple_id| IdentityProvider.new('simple_id' => simple_id, 'entity_id' => simple_id) }
    )

    FEDERATION_REPORTER.report_sign_in(journey.transaction, request)
    render 'index'
  end

  def select_idp
    select_viewable_idp(params.fetch('entity_id')) do |idp|
      sign_in(idp)
      redirect_to redirect_to_idp_path
    end
  end

  def select_idp_ajax
    select_viewable_idp(params.fetch('entityId')) do |idp|
      sign_in(idp)
      provider_request = journey.idp_authn_request
      render json: provider_request
    end
  end

private

  def sign_in(idp)
    journey.confirm_sign_in(idp)
    set_journey_hint(idp.entity_id)
    FEDERATION_REPORTER.report_sign_in_idp_selection(request, idp.display_name)
  end

  def unavailable_idps
    api_idp_simple_ids = journey.identity_providers.map(&:simple_id)
    UNAVAILABLE_IDPS.reject { |simple_id| api_idp_simple_ids.include?(simple_id) }
  end
end
