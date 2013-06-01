class AuditsController < ApplicationController
  # GET /audits
  # GET /audits.json
  def index
    @audits = Audited::Adapters::ActiveRecord::Audit.where(user_id: current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audits }
    end
  end
end
