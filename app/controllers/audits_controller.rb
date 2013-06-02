class AuditsController < ApplicationController
  # GET /audits
  # GET /audits.json
  def index
    @audits = Audited::Adapters::ActiveRecord::Audit.where(user_id: current_user.id)
    
    if request.xhr?
      return render partial: 'audits'
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audits }
    end
  end
end
