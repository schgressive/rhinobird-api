namespace :s3_assets do
  desc "Rename S3 stream's to use the slug hash"
  task :rename_objects => :environment do
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV["AWS_BUCKET"]]
    streams = Stream.all #Stream.where(hash_token: ["53f6b47e90cb7e880cfab12c"])
    streams.each do |stream|
      puts "Processing stream #{stream.to_param} - URL: #{stream.thumbnail.url}"
      if (stream.thumbnail.present?)
      unless (stream.thumbnail.url.match(stream.hash_token))
        puts "Need to move to #{stream.hash_token}"
        s3 = stream.thumbnail.s3_object
        new_name = bucket.objects["#{stream.hash_token}-original.jpg"]
        new_object = s3.copy_to(new_name)
      end
      else
        puts "Skipping... no image"
      end
    end
  end

end
