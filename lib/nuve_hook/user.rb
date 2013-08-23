module NuveHook
  module User
    extend ActiveSupport::Concern

    included do

      def vj_token
        NuveHook::Nuve.create_access_token(self.vj_room) if valid_token?
      end

      def check_vj_status
        if valid_token? && NuveHook::Nuve.room_exists?(self.username)
          self.vj_room = nil
          self.stream_pools.delete_all
          self.save
        end
      end

    end

    # checks if the user has a valid token
    def valid_token?
      self.vj_room && !self.vj_room.empty?
    end

    # check for streams to create room
    def check_vj_token
      self.stream_pools.empty? ? ensure_closed_channel : ensure_active_channel
    end

    # ensures there's a datachannel for the VJ
    def ensure_active_channel
      unless valid_token?
        room = NuveHook::Nuve.create_room(self.username)
        self.vj_room = room["_id"]
        self.save
      end
    end

    def ensure_closed_channel
      NuveHook::Nuve.delete_room(self.vj_room) if valid_token?
    end

  end
end

