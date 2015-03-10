class Channel < ActiveRecord::Base
  # Validations
  validates :name, presence: true, uniqueness: true, format: {with: /^[a-zA-Z][\w]+$/}

  # Friendly ID
  extend FriendlyId
  friendly_id :name

  # Relations
  has_and_belongs_to_many :streams

  def most_liked_streams
    streams.with_status(:live, :archived).includes(:user).order("likes DESC").limit(3)
  end

  def update_total_watches!
    self.update_column :stream_likes, self.streams.sum(:likes)
  end

  # Parses a caption and returns channel objects
  def self.get_channels(caption)
    channels = []
    Twitter::Extractor.extract_hashtags(caption) do |name|
      channels << Channel.find_or_create_by_name(name)
    end

    channels
  end
end
