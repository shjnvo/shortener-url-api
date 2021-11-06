class ApplicationController < ActionController::API
  include Pagy::Backend
  before_action :require_user

  private

  def require_user
    render json: { message: I18n.t('responce_message.please_login') }, status: :unauthorized if current_user.blank? 
  end

  def current_user
    token = request.headers['Authentication'].presence
    decode = JwtService.decode token
    return if decode.blank?
    User.unlockeds.find_by(token: decode['user_token'])
  end

  def user_access_by_key
    access_key = request.headers['X-AccessKey'].presence
    return if access_key.blank?
    User.unlockeds.find_by(access_key: access_key)
  end
end
