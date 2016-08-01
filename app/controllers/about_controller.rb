class AboutController < ApplicationController
  layout 'slides', except: [:choosing_a_company]

  def index
    FEDERATION_REPORTER.report_registration(
      current_transaction,
      request
    )
    ab_test(:remove_logos) do |alternative, meta|
      render meta[:index_page]
    end
  end

  def certified_companies
    @identity_providers = IDENTITY_PROVIDER_DISPLAY_DECORATOR.decorate_collection(current_identity_providers)
    ab_test(:remove_logos) do |alternative, meta|
      render meta[:certified_companies_page]
    end
  end

  def identity_accounts
    ab_finished(:remove_logos)
  end
end
