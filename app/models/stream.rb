class Stream < ActiveRecord::Base
  attr_accessible :desc, :geo_reference, :id, :lat, :lng, :started_on, :title, :url
  validates :title, presence: true
end
