class PlacesController < ApplicationController
  def index
  end

  def show
      @place = BeermappingApi.place_in(session['last_city'], params[:id])
    end

  def search
    city = params[:city]
    @places = BeermappingApi.places_in(city)
    session['last_city'] = city
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{city}"
    else
      render :index
    end
  end
end
