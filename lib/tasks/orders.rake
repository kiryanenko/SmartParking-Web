namespace :orders do
  desc 'Stop all reservations where booked time finished'
  task :stop_reservations => :environment do
    Order.stop_reservations
  end
end
