ymaps.ready ()->
  circle = null
  places = []
  table = $ "#table"

  remove_placemarks = ()->
    if places.length > 0
      $.each places, (index, place)->
        myMap.geoObjects.remove place

  add_placemarks = (new_placemarks)->
    $.each new_placemarks, (index, place)->
      pm = new ymaps.Placemark [place.lat, place.lon],
      {
        iconContent: "#{(place.distanse / 1000).toFixed(2)} км"
        hintContent: place.address
      },
      {
        preset: 'islands#blueStretchyIcon'
      }
      places.push(pm)
      myMap.geoObjects.add pm

  add_circle = (center)->
    circle = new ymaps.Circle [center,  4000],
      {
        hintContent: "Нажмите на круг, чтобы убрать его"
      },{
        strokeOpacity: 0.7
        strokeWidth: 2
        opacity: 0.4
      }

    myMap.geoObjects.add circle

  remove_circle = ()->
    if circle
      myMap.geoObjects.remove circle
      remove_circle_events()
      clear_table()

  add_circle_events = ()->
    circle.events.add 'click', (e)->
      remove_circle()
      remove_placemarks()

  remove_circle_events = ()->
    circle.events.remove 'click'

  add_rows = (places)->
    if places.length > 0
      body = table.find 'tbody'
      $.each places, (index, place)->
        row = "
          <tr>
            <td>#{place.address}</td>
            <td>#{place.distanse.toFixed(2)} м.</td>
          </tr>
        "
        body.append row

  clear_table = ()->
    body = table.find 'tbody'
    body.empty()


  myMap = new ymaps.Map "map",
    center: [55.744212, 37.647365]
    zoom: 10
    controls: ['fullscreenControl', 'zoomControl']

  # ресуем круг
  myMap.events.add 'click', (e)->
    remove_circle()
    add_circle e.get('coords')
    add_circle_events()

  # загружаем метки
  myMap.events.add 'click', (e)->
    coords = e.get('coords')
    remove_placemarks()
    clear_table()
    $.get "/place/around.json?lat=#{coords[0]}&lon=#{coords[1]}", (resp)->
      if resp.places
        add_placemarks resp.places
        add_rows(resp.places)


