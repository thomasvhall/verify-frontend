class RedirectToIdpController < ApplicationController
  def index
    @request = journey.idp_authn_request
  end
end
