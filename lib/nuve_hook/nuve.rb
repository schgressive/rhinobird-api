module NuveHook
  module Nuve

    # checks for room existance
    def self.room_exists?(roomId)
      users = NUVE.getUsers(roomId)

      !(users.include?("not exist") || users.include?("MAuth"))
    end

    # checks for room existance or empty room
    def self.live_room?(roomId)

      json_reply = NUVE.getUsers(roomId)
      return false if (json_reply.include?("not exist") || json_reply.include?("MAuth"))

      users = JSON.parse(json_reply)
      users.reject! {|u| u.to_s.include?("null") }
      return false if users.empty?

      true
    end

    def self.delete_room(roomId)

      Rails.logger.info "Deleting room #{roomId}"
      begin
        NUVE.deleteRoom(roomId)
      rescue Exception => e
        Rails.logger.debug "Error deleting room #{e.message}"
      end

    end

    # Creates a room in lynckia en returns the room JSON
    def self.create_room(room_name)
      Rails.logger.info "creating room(#{room_name}) in Lynckia"
      begin
        response = NUVE.createRoom(room_name)
      rescue Exception => e
        response = '{}'
        Rails.logger.debug "Error on create room: #{e.inspect}"
      end
      #HOOK for NUVE
      JSON.parse(response)
    end

    #override token field on stream
    def self.create_access_token(roomId)
      begin
        NUVE.createToken(roomId, "user#{Time.now.to_i}", "viewer")
      rescue Exception => e
        Rails.logger.debug "Error generating token for room: #{e.message}"
      end
    end
  end
end
