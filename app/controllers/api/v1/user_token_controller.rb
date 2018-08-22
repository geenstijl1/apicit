class Api::V1::UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token

  rescue_from Knock.not_found_exception_class_name, with: :bad_request

  # excepcion email-password al logearse
  def bad_request
    render json: { status: 401, msg: "Invalid email address or password" }
  end
end
