Paperclip.interpolates :slug do |attachment, style|
  attachment.instance.hash_token
end
