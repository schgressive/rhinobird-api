class Timeline < ActiveRecord::Base

  belongs_to :resource, polymorphic: true
  belongs_to :user

  validates :resource, presence: true

  before_create do
    self.user_id = resource.user_id if resource.respond_to? :user_id
  end

  has_attached_file :thumbnail, styles: {
    small: '33%',
    medium: '66%',
    large: '100%'
  },
  s3_headers: {
    'Content-Disposition' => "attachment;"
  },
  url: "/system/:hash-:style.:extension",
  hash_secret: "hash_secret"

end
