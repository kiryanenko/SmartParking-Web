require './app/utils/random'

namespace :db do
  desc 'This task generate test data for DB'
  task :test_data, [:parkings_count, :places_per_parking] => :environment do |t, args|
    args.with_defaults(:parkings_count => 500, :places_per_parking => 50)
    puts "Start generating #{args.parkings_count} parkings with #{args.places_per_parking} places"

    titles = [
        "Центр Международной торговли",
        "ТПУ Ботанический сад",
        "ТРЦ «Золотой Вавилон»",
        "БЦ «Silver Stone»",
        "ТЦ «METRO Cash and Carry»",
        "Газпромнефть",
        "Горздрав",
        "ТЦ «Гвоздь»",
        "Железнодорожный вокзал Белорусский",
        "Парковка для владельцев парковочных разрешений",
        "Больница № 11",
        "Московский областной КДЦ для детей",
        "Городская клиническая больница №4",
        "ФКУЗ Центральная стоматологическая поликлиника МВД России",
        ""
    ].shuffle!
    descriptions = [
        "Адрес: Улица Ильинка, Дом 13",
        "Адрес: Подколокольный переулок, дом 10А/2, строение 1",
        "ФКУЗ Центральная стоматологическая поликлиника МВД России",
        "Адрес: Овчинниковская Набережная, Дом 6, Строение 1",
        "60 руб./ч-первый час, далее-100 р/ч (8-20 ч.), 60 р/ч (20-8)",
        "Подземная, платная",
        "Открытая, неохраняемая, гостевая",
        "Мойка, туалет, кафе",
        "Оплата через паркомат, оплата через приложение",
        "Перехватывающая, охраняемая, наземная",
        "Шиномонтаж, автосервис, мойка",
        ""
    ].shuffle!

    user = User.first

    args.parkings_count.times do |i|
      sensor = Sensor.create!(user: user)
      base_coord = {lat: Random.rand(55.60..55.90), lng: Random.rand(37.38..37.83)}

      polygon = []
      Random.rand(3..6).times do
        polygon.push({
                         lat: base_coord[:lat] + Random.rand(-0.003..0.003),
                         lng: base_coord[:lng] + Random.rand(-0.003..0.003)
                     })
      end

      start_point = polygon.min { |a, b| a[:lat] != b[:lat] ? a[:lat] <=> b[:lat] : a[:lng] <=> b[:lng] }
      polygon.sort! do |a, b|
        next -1 if a[:lat] == start_point[:lat] && a[:lng] == start_point[:lng]
        next 1 if b[:lat] == start_point[:lat] && b[:lng] == start_point[:lng]
        next a[:lng] <=> b[:lng] if start_point[:lat] == a[:lat] && start_point[:lat] == b[:lat]
        next start_point[:lng] <=> a[:lng] if start_point[:lat] == a[:lat]
        next b[:lng] <=> start_point[:lng] if start_point[:lat] == b[:lat]
        tan_a = (a[:lng] - start_point[:lng]) / (a[:lat] - start_point[:lat])
        tan_b = (b[:lng] - start_point[:lng]) / (b[:lat] - start_point[:lat])
        next a[:lat] <=> b[:lat] if tan_a == tan_b
        tan_b <=> tan_a
      end

      polygon.push polygon[0]
      area = 'POLYGON (('
      area += polygon.map { |coord| "#{coord[:lat]} #{coord[:lng]}" }.join(', ')
      area += '))'

      parking = Parking.new(
          title: "Автопаркинг № #{i} " + titles[i % titles.size],
          description: descriptions[i % descriptions.size],
          cost: Random.rand(0..300),
          user: user,
          area: area,
          start_time: Random.rand_bool ? Time.new(Random.rand(0..86399)) : nil,
          end_time: Time.new(Random.rand(0..86399))
          )

      unless parking.save
        p parking
        p parking.errors
        p area
      end


      Random.rand(1..args.places_per_parking).times do |j|
        place = ParkingPlace.new(
            title: j.to_s,
            sensor: sensor,
            parking: parking,
            place_id: j,
            coord: "POINT (#{base_coord[:lat] + Random.rand(-0.003..0.003)} #{base_coord[:lng] + Random.rand(-0.003..0.003)})",
            for_disabled: Random.rand_bool(0.2),
            booked: Random.rand_bool,
            free: Random.rand_bool,
            connected: Random.rand_bool(0.1),
            can_book: Random.rand_bool(0.7),
            )

        unless place.save
          p place
          p place.errors
        end
      end

      puts "Generated #{i} parkings" if i % 50 == 0
    end
  end
end
