class ParserController < ApplicationController
  def index
  end

  def show
           #destination_values
    default_atlas_id ||= "355064"
    @destination_name= DestinationObject.destination_name(default_atlas_id)

    @destination=find_destination_child(default_atlas_id)

    @links="none yet"
  end

  protected


  def find_destination_child(atlas_id)
     DestinationObject.new(atlas_id)

  end


end
