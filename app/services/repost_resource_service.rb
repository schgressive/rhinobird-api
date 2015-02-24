class RepostResourceService < Struct.new(:resource, :user)

  def run
    new_resource = build_new_resource
    new_resource
  end

  def build_new_resource
    new_resource = object_class.new(resource.attributes.except([:created_at, :updated_at]))
    new_resource.user = user
    new_resource.source = resource
    new_resource.thumbnail = resource.thumbnail
    new_resource.save!
    new_resource
  end

  def object_class
    @klass ||= resource.class
  end
end
