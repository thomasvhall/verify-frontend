class StartController < ApplicationController
  layout 'slides'

  def index
    @form = StartForm.new({})
    FEDERATION_REPORTER.report_start_page(current_transaction, request)
    render :start
  end

  def request_post
    @form = StartForm.new(params['start_form'] || {})
    if @form.valid?
      redirect_to @form.registration? ? about_path : sign_in_path
    else
      flash.now[:errors] = @form.errors.full_messages.join(', ')
      render :start
    end
  end
end
