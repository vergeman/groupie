class SchedulesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_user, :only => :destroy

  def destroy
    @schedule = Schedule.find(params[:id])
    @place = @schedule.place

    #recoup assocated votes (slow we can likely optimize ehre)
    @event.participants.each do |p|
      if !p.votes.empty?

        unless p.votes.find_by_place_id(@place.id).empty.nil?
          votes = p.votes.find_by_place_id(@place.id).vote
          p.update_attributes(:votes_remaining => p.votes_remaining + votes)
          
          #remove vote record
          @vote = p.votes.find_by_place_id(@place)
          @vote.destroy
        end

      end
    end

    #destroy schedule record
    @schedule.destroy

    #redirect
    redirect_to(@event)
  end


  def verify_user
    @schedule = Schedule.find(params[:id])
    @event = @schedule.event

    redirect_to @event unless User.find(current_user).id == @schedule.admin_id

  end

end

