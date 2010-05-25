namespace :radiant do
  namespace :extensions do
    namespace :ro do
      
      desc "Runs the migration of the Romanian Language Pack extension"
      task :migrate => :environment do
        puts "This extension does not affect the database. Nothing done. Move along."
      end
      
      desc "Copies public assets of the Romanian Language Pack to the instance public/ directory."
      task :update => :environment do
        puts "This extension has no public assets. Nothing done. Move along."
      end  
      
      desc "Syncs all available translations for this ext to the English ext master"
      task :sync => :environment do
        # The main translation root, basically where English is kept
        language_root = RomanianLanguagePackExtension.root + "/config/locales"
        words = TranslationSupport.get_translation_keys(language_root)
        
        Dir["#{language_root}/*.yml"].each do |filename|
          next if filename.match('_available_tags')
          basename = File.basename(filename, '.yml')
          puts "Syncing #{basename}"
          (comments, other) = TranslationSupport.read_file(filename, basename)
          words.each { |k,v| other[k] ||= words[k] }  # Initializing hash variable as empty if it does not exist
          other.delete_if { |k,v| !words[k] }         # Remove if not defined in en.yml
          TranslationSupport.write_file(filename, basename, comments, other)
        end
      end
    end
  end
end
