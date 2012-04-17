namespace :db do
    require 'sequel'
    Sequel.extension :migration
    migration_dir = "models/migrations"

=begin
    task :migrate do
        puts "task migrate"
        m = Sequel::Migrator
        db = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://decks.sqlite')
        dir = "migrations"
        target = ENV['TARGET'] ? ENV['TARGET'].to_i : nil
        current = ENV['CURRENT'] ? ENV['CURRENT'].to_i : nil
        puts "target: #{target}, current: #{current}"
        m.run(db, dir, :target => target, :current => current)
        puts "migrator finished running"
    end
=end
    
    task :environment, [:env] do |cmd, args|
     # Padrino.mounted_apps.each do |app|
     #   app.app_obj.setup_application!
     # end
     #ENV["RACK_ENV"] = args[:env] || "development"
     @@env = args[:env] || "development"
     require 'models/init'
    end

    namespace :migrate do

      desc "Perform automigration (reset your db data)"
      task :auto => :environment do
        ::Sequel.extension :migration
        ::Sequel::Migrator.run Sequel::Model.db, migration_dir, :target => 0
        ::Sequel::Migrator.run Sequel::Model.db, migration_dir
        puts "<= sq:migrate:auto executed"
      end

      desc "Perform migration up/down to VERSION"
      task :to, [:version] => :environment do |t, args|
        version = (args[:version] || ENV['VERSION']).to_s.strip
        ::Sequel.extension :migration
        raise "No VERSION was provided" if version.empty?
        ::Sequel::Migrator.apply(Sequel::Model.db, migration_dir, version.to_i)
        puts "<= sq:migrate:to[#{version}] executed"
      end

      desc "Perform migration up to latest migration available"
      task :up => :environment do
        puts Sequel::Model.db.inspect 
        ::Sequel.extension :migration
        ::Sequel::Migrator.run Sequel::Model.db, migration_dir
        puts "<= sq:migrate:up executed"
      end

      desc "Perform migration down (erase all data)"
      task :down => :environment do
        ::Sequel.extension :migration
        ::Sequel::Migrator.run Sequel::Model.db, migration_dir, :target => 0
        puts "<= sq:migrate:down executed"
      end
    end
end 
