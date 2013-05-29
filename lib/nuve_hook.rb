module NuveHook
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_licode_room
    before_create :change_token

    def token
      generate_room_token
    end
  end

  #callback for room deletion
  def delete_licode_room
    NUVE.deleteRoom(self.to_param)
  end

  #assign room ID to stream hash_token
  def change_token
    #HOOK for NUVE
    room = JSON.parse(NUVE.createRoom(self.title))
    self.hash_token = room["_id"]
  end

  #override token field on stream
  def generate_room_token
    NUVE.createToken(self.to_param, "user#{Time.now.to_i}", "viewer")
  end
end
