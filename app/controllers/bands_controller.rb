require 'pry'
class BandsController < ApplicationController
  before_action :set_band, only: [:show, :update, :destroy]

  # GET /bands
  def index
    @bands = Band.all
    render :json => @bands, :include => {:albums => {:except => [:created_at, :updated_at]}}
  end

  # POST /bands
  def create
    @band = Band.create!(band_params)
    json_response(@band, :created)
  end

  # GET /bands/:name
  def show
    render :json => @band, :include => {:albums => {:except => [:created_at, :updated_at]}}
  end

  # PUT /bands/:name
  def update
    @band.update!(band_params)
    head :no_content
  end

  # DELETE /bands/:name
  def destroy
    @band.destroy!
    head :no_content
  end

  private

  def band_params
    # whitelist params
    band = params["band"]
    name = band["name"].split(" ").map(&:downcase).join("-")
    parameters = {
        name: name,
        origin: band["origin"],
        website: band["website"],
        years_active: band["years_active"],
        members:  band["members"] || []
    }
    ActionController::Parameters.new(parameters).permit!
  end

  def set_band
    # Assuming that the url contains name of band instead of id
    @band = Band.find_by_name!(params[:id])
  end

end
