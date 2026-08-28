class AmberAlertsController < ApplicationController
  def index
    @lat = current_user.latitude || -33.8688
    @lng = current_user.longitude || 151.2093
    @radius = 10.to_f

    @alerts = AmberAlert.open
                        .near([@latitude, @longitude], @radius, units: :km)
                        .includes(:creator, :alert_responses,
                                  pet: { avatar_attachment: :blob })
  end

  def new
  end

  def create
  end

  def show
  end
end
