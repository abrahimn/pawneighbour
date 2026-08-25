class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_activity_attention_count, if: :user_signed_in?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: %i[name location mobile])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name location mobile])
  end

  def set_activity_attention_count
    @activity_attention_count = Offer
                                .pending
                                .joins(listing: :pet)
                                .where(pets: { user_id: current_user.id })
                                .count
  end
end
