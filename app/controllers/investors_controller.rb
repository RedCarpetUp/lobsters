class InvestorsController < ApplicationController
  before_action :require_user

  ITEMS_PER_PAGE = 10

  def index

    @page = 1
    if params[:page].to_i > 0
      @page = params[:page].to_i
    end

  	@title="Investors"
  	@cur_url = "/investors"
  	@investors = User.where(:is_investor => true).where(:banned_at => nil).offset((@page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
  end

end