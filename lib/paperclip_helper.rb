class PaperclipHelper
  def self.process(value, name)
    if value.present? && is_base_64?(value)
      content, base64 = value.split(";")
      base64 = base64.split(",").last
      content = content.split(":").last

      PaperclipAttachment.open(Base64.decode64(base64)) do |data|
        data.original_filename = "#{name}.png"
        data.content_type = content
        yield data
      end
    end
  rescue
    Rails.logger.error "Invalid base64 image"
  end

  def self.is_base_64?(str)
    str.match(/(^data:image\/.*,)|(\.(jp(e|g|eg)|gif|png|bmp|webp)((\?|#).*)?$)/i);
  end
end

