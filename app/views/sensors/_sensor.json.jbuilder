json.extract! sensor, :id, :id, :user_id, :sampling_period, :sending_period, :day_cast, :night_cast, :day_start_time, :night_start_time, :created_at, :updated_at
json.url sensor_url(sensor, format: :json)
