class Place < ActiveRecord::Base

  attr_accessor :dist

  def self.around lat, lon, distanse = 4000
    lat = lat.to_f
    lon = lon.to_f
    # Чтобы не фильтровать все 50 записей, сперва выберем те, что находятся в квадрате 8х8 км, вокруг точки
    # в одном градусе долготы 111.11 км
    # количество км в одном градусе долготы зависит от паралели
    dlon = 8.0 / 111.11
    dlat = 8.0 / 111.11 * Math.cos( lat.to_f / 180 * Math::PI )
    # полученые записи фильтруем, используя более сложную формулу подсчера расстояния между точками на сфере
     # сортируем записи по расстоянию от точки
    places = where('lat between ? and ? and lon between ? and ?', (lat-dlat), (lat+dlat), (lon-dlon), (lon+dlon))
      .to_a.delete_if{|p| p.distanse(lat, lon) > distanse}
      .sort! {|a,b| a.dist <=> b.dist}
    places
  end

  def distanse lat, lon
    # радиус планеты
    rad = 6378100
    # переводим в радианы координаты щелчка и координаты места
    fi1 = self.lat / 180 * Math::PI
    fi2 = lat.to_f / 180 * Math::PI
    la1 = self.lon / 180 * Math::PI
    la2 = lon.to_f / 180 * Math::PI
    dlon = (lon.to_f - self.lon) / 180 * Math::PI
    # посчитаем синусы и косинусы необходимых величин
    cos_fi1  = Math.cos(fi1)
    cos_fi2  = Math.cos(fi2)
    sin_fi1  = Math.sin(fi1)
    sin_fi2  = Math.sin(fi2)
    cos_dlon = Math.cos(dlon)
    sin_dlon = Math.sin(dlon)
    # числитель
    a = Math.sqrt (cos_fi2 * sin_dlon)**2 + (cos_fi1 * sin_fi2 - sin_fi1 * cos_fi2 * cos_dlon)**2
    # знаменатель
    b = sin_fi1 * sin_fi2 + cos_fi1 * cos_fi2 * cos_dlon
    # дистанция от точни до места
    self.dist = Math.atan2( a, b ) * rad
    self.dist
  end

end
