module NuveHook
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_licode_room
    before_create :change_token

    def token
      generate_room_token
    end

    def room_name
      "LicodeRoom#{self.id}"
    end
  end

  #callback for room deletion
  def delete_licode_room
    Rails.logger.info "Deleting room #{self.to_param}"
    begin
      NUVE.deleteRoom(self.to_param)
    rescue Exception => e
      Rails.logger.debug "Error deleting room #{e.message}"
    end

  end

  #assign room ID to stream hash_token
  def change_token
    Rails.logger.info "creating room(#{self.room_name}) in Lynckia"
    begin
      response = NUVE.createRoom(self.room_name)
    rescue Exception => e
      response = '{}'
      Rails.logger.debug "Error on create room: #{e.inspect}"
    end
    #HOOK for NUVE
    room = JSON.parse(response)
    self.hash_token = room["_id"]
  end

  #override token field on stream
  def generate_room_token
    begin
      NUVE.createToken(self.to_param, "user#{Time.now.to_i}", "viewer")
    rescue Exception => e
      Rails.logger.debug "Error generating token for room: #{e.message}"
    end
  end
end
