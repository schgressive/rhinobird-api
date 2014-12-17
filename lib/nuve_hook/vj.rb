module NuveHook
  module Vj
    extend ActiveSupport::Concern

    included do

      def vj_token
        new_token = nil
        if self.status.created? || self.status.live?
          ensure_active_channel
          new_token = NuveHook::Nuve.create_access_token(self.vj_room)
          self.update_attributes(status: :pending) if new_token =~ /not exist/
        end
        new_token
      end

      # Refresh the flag if the room doesn't exist or the user list is empty
      def refresh_live_status
        # only check if flag is live
        if self.status.live?
          is_live = NuveHook::Nuve.live_room?(self.vj_room, vj: true)
          unless is_live
            self.update_attributes(status: :pending)
          end
        end

        self.status.live?
      end


    end

    # checks if the user has a valid token
    def valid_token?
      self.vj_room && !self.vj_room.empty?
    end

    # ensures there's a datachannel for the VJ
    def ensure_active_channel
      unless valid_token?
        room = NuveHook::Nuve.create_room("#{self.user.try(:username)}-#{self.channel.try(:name)}")
        self.vj_room = room["_id"]
        self.save
      end
    end

    def ensure_closed_channel
      NuveHook::Nuve.delete_room(self.vj_room) if valid_token?
    end

  end
end

