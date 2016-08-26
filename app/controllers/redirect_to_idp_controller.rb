class RedirectToIdpController < ApplicationController
  def index
    @request = IdentityProviderRequest.new(
      journey.idp_authn_request,
      journey.selected_idp.simple_id,
      selected_answer_store.selected_answers
    )
  end
end
