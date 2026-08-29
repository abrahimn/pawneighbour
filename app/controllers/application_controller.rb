class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_activity_attention_count, if: :user_signed_in?

  protected

  # Devise also uses this destination after a successful sign-up.
  def after_sign_in_path_for(_resource)
    listings_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: %i[name location mobile])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name location mobile])
  end

  def set_activity_attention_count
    @activity_attention_count = Offer.pending.where(listing: current_user.listings).count
  end
end
