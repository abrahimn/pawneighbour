class AlertResponsesController < ApplicationController
  def create
    @alert    = AmberAlert.find(params[:amber_alert_id])
    @response = @alert.alert_responses.build(response_params.merge(spotter: current_user))

    if @response.save
      redirect_to @alert, notice: "Thank you — #{@alert.pet.name}'s owner has been notified."
    else
      redirect_to @alert, alert: @response.errors.full_messages.to_sentence
    end
  end

  private

  def response_params
    params.require(:alert_response).permit(:location, :date, :time, :notes, photos: [])
  end
end
