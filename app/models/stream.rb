class Stream < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  validates :title, :desc, presence: true
end
