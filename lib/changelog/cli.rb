require 'thor'
require 'changelog'
require 'changelog/entry'
require 'changelog/generator'
require 'changelog/bundler'
require 'colorize'

module Changelog
    class CLI < Thor
        default_task :gen_entry

        method_option :ammend, :type => :boolean, :default => false, :desc => 'Amend the previous commit'
        method_option :force, :type => :string, :aliases => "-f", :desc => 'Overwrite an existing entry'
        method_option "merge-request", :type => :numeric, :aliases => "-m", :desc => 'Merge Request ID'
        method_option "issue", :type => :numeric, :aliases => "-i", :desc => 'Issue ID'
        method_option "dry-run", :type => :boolean, :aliases => "-n", :desc => "Don't actually write anything, just print"
        method_option :author, :type => :string, :aliases => "-u", :desc => 'Overwrite the author of the change'
        method_option :type, :type => :string, :aliases => "-t", :desc => "The category of the change", :enum => Changelog::Entry::TYPES.map(&:name)
        desc 'gen [TITLE]', 'Generate a new changelog entry'
        def gen_entry(title="") 
            type = options.type || read_type
            
            generator = Changelog::Generator.new(title, type, options.author, options.issue, options["merge-request"], options.amend, options.force)
            generator.execute(options["dry-run"])
        end
        
        
        method_option "changelog-file", :type => :string, :aliases => "-c", :desc => 'The name of the changelog file'
        method_option "include-date", :type => :boolean, :aliases => "-d", :desc => 'Include the date in the release'
        method_option "dry-run", :type => :boolean, :aliases => "-n", :desc => "Don't actually write anything, just print"
        method_option "no-commit", :type => :boolean, :default => false, :desc => 'Do not commit the changelog'
        method_option :force, :type => :string, :aliases => "-f", :desc => 'Write an empty version if there is no entries'
        desc 'bundle VERSION', 'Bundle the changelogs entry to a new version'
        def bundle_entries(version) 
            semver = Changelog::SemanticVersion::new(version)

            bundler = Changelog::Bundler.new(semver, options['changelog-file'], options['include-date'], options['no-commit'], options["dry-run"],  options["force"])
            bundler.execute
        end

        


        private

        def read_type
            read_type_message

            type = Changelog::Entry::TYPES[$stdin.getc.to_i - 1]
            assert_valid_type!(type)

            type.name
        end

        def read_type_message
            $stdout.puts "\n>> Please specify the index for the category of your change:"
            Changelog::Entry::TYPES.each_with_index do |type, index|
                $stdout.puts "#{index + 1}. #{type.description}"
            end
            $stdout.print "\n?> "
        end

        def assert_valid_type!(type)
            unless type
                raise Abort, "Invalid category index, please select an index between 1 and #{Changelog::Entry::TYPES.length}"
            end
        end
   end 
end