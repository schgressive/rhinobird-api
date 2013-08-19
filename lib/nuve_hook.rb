module NuveHook
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_licode_room
    before_create :change_token

    # returns the token if the stream is live
    def token
      self.live ? generate_room_token : nil
    end

    # Refresh the flag if the room doesn't exist or the user list is empty
    def refresh_live_status
      # only check if flag is live
      if self.live
        live_status = true
        users = NUVE.getUsers(self.hash_token)

        live_status = false if users.include?("not exist") || JSON.parse(users).empty?

        self.live = live_status
        self.save
      end
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
    room_name = "LicodeRoom-#{Digest::MD5.hexdigest(self.inspect + Time.now.to_s)}"
    Rails.logger.info "creating room(#{room_name}) in Lynckia"
    begin
      response = NUVE.createRoom(room_name)
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
