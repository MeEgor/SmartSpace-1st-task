class PlaceController < ApplicationController
  def around
    @places = Place.around params[:lat], params[:lon]
  end
end
