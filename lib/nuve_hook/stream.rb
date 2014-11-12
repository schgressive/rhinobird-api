module NuveHook
  module Stream
    extend ActiveSupport::Concern

    included do

      before_destroy :delete_licode_room
      before_create :setup_licode_room

      # returns the owner token
      def owner_token
        access_token = nil
        if self.status.created? || self.status.live?
          access_token = NuveHook::Nuve.create_owner_token(self.to_param)
          # set live to false if unexisting room
          if access_token =~ /not exist/
            self.update_attributes(status: :pending)
            return nil
          end
        end
        access_token
      end

      # returns an access token if the room is live
      def token
        access_token = nil
        if self.status.live?
          access_token = NuveHook::Nuve.create_access_token(self.to_param)
          # set live to false if unexisting room
          if access_token =~ /not exist/
            self.update_attributes(status: :pending)
            return nil
          end
        end
        access_token
      end

      # Refresh the flag if the room doesn't exist or the user list is empty
      def refresh_live_status
        # only check if flag is live
        if self.status.live?
          is_live = NuveHook::Nuve.live_room?(self.hash_token)
          unless is_live
            self.update_attributes(status: :pending)
            begin
              NuveHook::Nuve.delete_room(self.hash_token)
            rescue
              Rails.logger.info "Couldn't delete licode room"
            end
          end
        end

        self.status.live?
      end

    end

    #callback for room deletion
    def delete_licode_room
      NuveHook::Nuve.delete_room(self.to_param)
    end

    # assign room ID to stream hash_token
    def setup_licode_room
      room_name = "LicodeRoom-#{Digest::MD5.hexdigest(self.inspect + Time.now.to_s)}"
      room = NuveHook::Nuve.create_room(room_name)
      self.hash_token = room["_id"]
    end

  end
end
