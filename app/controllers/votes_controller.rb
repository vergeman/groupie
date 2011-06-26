class VotesController < ApplicationController
  before_filter :authenticate_user!

  #votes POST   /votes(.:format)                       {:action=>"create", :controller=>"votes"}
  #vote PUT    /votes/:id(.:format)                   {:action=>"update", :controller=>"votes"}
  #vote DELETE /votes/:id(.:format)                   {:action=>"destroy", :controller=>"votes"}

  def create

    respond_to do |format|
      format.js {
        #TODO: check if vote for item by participant already exists, redirect to update
        @event = Event.find(params[:event_id])
        @place = Place.find(params[:place_id])
        submit_vote = params[:vote]

        @participant = @event.participants.find_by_user_id(current_user)

        if (@vote = @participant.votes.find_by_place_id(@place))
          @vote.update_attributes(:vote => @vote.vote += submit_vote.to_i)
        else
          @vote = @participant.votes.create(:place_id => params[:place_id], 
                                            :vote => params[:vote])
        end

        render :json => @vote.vote
      }
      format.html { render :nothing => true }

    end
    
  end
  


  def update

    @vote = Vote.find(params[:id])
    @vote.update_attributes(:vote => params[:vote])

    respond_to do |format|
      format.html { render :nothing => true }
    end
  end


  def destroy
  end


  

end
