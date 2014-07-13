object false

child @places, root: "places", object_root: false do
  attributes :id, :address, :lat, :lon

  node :distanse do |place|
    place.dist
  end
end
