module NuveHook
  module Stream
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
          self.live = NuveHook::Nuve.live_room?(self.hash_token)
          self.save
        end

        self.live
      end

    end

    #callback for room deletion
    def delete_licode_room
      NuveHook::Nuve.delete_room(self.to_param)
    end

    #assign room ID to stream hash_token
    def change_token
      room_name = "LicodeRoom-#{Digest::MD5.hexdigest(self.inspect + Time.now.to_s)}"
      room = NuveHook::Nuve.create_room(room_name)
      self.hash_token = room["_id"]
    end

    #override token field on stream
    def generate_room_token
      NuveHook::Nuve.create_access_token(self.to_param)
    end

  end
end
