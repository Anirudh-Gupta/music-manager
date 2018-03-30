class AlbumsController < ApplicationController
  before_action :set_band
  before_action :set_album, only: [:show, :update, :destroy]

  # GET /bands/:band_name/albums
  def index
    json_response(@band.albums)
  end

  # GET /bands/:band_name/albums/:name
  def show
    json_response(@album)
  end

  # POST /bands/:band_name/albums
  def create
    @album = @band.albums.create!(album_params) if @band
    json_response(@album, :created)
  end

  # PUT /bands/:band_name/albums/:name
  def update
    @album.update(album_params)
    head :no_content
  end

  # DELETE /bands/:band_name/albums/:name
  def destroy
    @album.destroy
    head :no_content
  end

  private

  def album_params
    album = params["album"]
    raise ActiveRecord::RecordInvalid.new if album.empty?
    title = Album.formatted_name(album["title"])
    parameters = {
       title: title,
       year: album["year"],
       genre: album["genre"],
       number_of_tracks: album["number_of_tracks"],
       number_of_discs: album["number_of_discs"]
    }
    ActionController::Parameters.new(parameters).permit!
  end

  def set_band
    @band = Band.find_by_name!(params[:band_id])
  end

  def set_album
    @album = @band.albums.find_by_title!(params[:id]) if @band
  end
end
