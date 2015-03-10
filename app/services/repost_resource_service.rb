class RepostResourceService < Struct.new(:resource, :user)

  def run
    new_resource = build_new_resource
    increment_repost_count
    new_resource
  end

  def increment_repost_count
    resource.update_column :reposts, object_class.where(source_id: resource.id).count
  end

  def build_new_resource
    new_resource = object_class.new(resource.attributes.except([:created_at, :updated_at]))
    new_resource.user = user
    new_resource.source = resource
    new_resource.thumbnail = resource.thumbnail
    begin
      new_resource.save!
    rescue Paperclip::Errors::NotIdentifiedByImageMagickError => e
      Rails.logger.info "Saving without attachment #{e.message}"
      new_resource.thumbnail = nil
      new_resource.save!
    end
    new_resource
  end

  def object_class
    @klass ||= resource.class
  end
end
