namespace :rb do
  desc "Removes users(and data) queued for deletion"
  task :purge_users => :environment do
    puts "Starting user purge..."
    User.with_status(:for_deletion).each do |user|
      UserDeletionService.new(user, purge: true).run if user.should_delete?
    end
    puts "Finished user purge..."
  end
end
