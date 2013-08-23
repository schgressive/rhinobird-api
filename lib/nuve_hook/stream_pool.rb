module NuveHook
  module StreamPool
    extend ActiveSupport::Concern

    included do

      after_create :check_vj_token
      after_destroy :check_vj_token

    end

    # force check of VJ token
    def check_vj_token
      user.check_vj_token
    end

  end
end
