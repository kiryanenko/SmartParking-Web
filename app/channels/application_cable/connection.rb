module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :id

    def connect
      self.id = object_id
    end
  end
end
