module NuveHook
  module Vj
    extend ActiveSupport::Concern

    included do

      def vj_token
        ensure_active_channel
        NuveHook::Nuve.create_access_token(self.vj_room)
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

