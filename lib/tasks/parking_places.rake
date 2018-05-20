namespace :parking_places do
  desc 'Cancel all reservations where booked time finished'
  task :cancel_reservations => :environment do
    ParkingPlace.cancel_reservations
  end
end
