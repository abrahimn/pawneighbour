class AmberAlertsController < ApplicationController
  def index
    @lat = current_user.latitude || -33.8688
    @lng = current_user.longitude || 151.2093
    @radius = 10.to_f

    @alerts = AmberAlert.open
                        .near([@lat, @lng], @radius, units: :km)
                        .includes(:creator, :alert_responses,
                                  pet: { avatar_attachment: :blob })
  end

  def new
    if current_user.pets.none?
      redirect_to amber_alerts_path,
                  alert: "Add a pet before reporting one missing." and return
    end

    @alert = AmberAlert.new
    @pets  = current_user.pets.order(:name)
  end

  def create
    @alert = current_user.amber_alerts.build(alert_params)

    if @alert.save
      redirect_to @alert, notice: "Alert posted. Your neighbours can see it now."
    else
      @pets = current_user.pets.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @alert     = AmberAlert.find(params[:id])
    @sightings = @alert.alert_responses.includes(:spotter).order(date: :desc, time: :desc)
    @response  = AlertResponse.new
  end

  def resolve
    @alert = current_user.amber_alerts.find(params[:id])
    @alert.update!(resolved_at: Time.current)

    redirect_to amber_alerts_path, notice: "#{@alert.pet.name} is home. Alert closed."
  end

  private

  def alert_params
    params.require(:amber_alert).permit(:pet_id, :location, :date, :time, :details)
  end
end
