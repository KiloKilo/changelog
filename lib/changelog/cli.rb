require 'thor'
require 'changelog'
require 'changelog/entry'
require 'changelog/generator'
require 'colorize'

module Changelog
    class CLI < Thor

        method_option :ammend, :type => :boolean, :default => false, :desc => 'Amend the previous commit'
        method_option :force, :type => :string, :aliases => "-f", :desc => 'Overwrite an existing entry'
        method_option "merge-request", :type => :numeric, :aliases => "-m", :desc => 'Merge Request ID'
        method_option "issue", :type => :numeric, :aliases => "-i", :desc => 'Issue ID'
        method_option "dry-run", :type => :string, :aliases => "-n", :desc => "Don't actually write anything, just print"
        method_option :author, :type => :string, :aliases => "-u", :desc => 'Overwrite the author of the change'
        method_option :type, :type => :string, :aliases => "-t", :desc => "The category of the change", :enum => Changelog::Entry::TYPES.map(&:name)
        desc 'gen [TITLE]', 'Generate a new changelog entry'
        def gen_entry(title="") 
            type = options.type || read_type

            generator = Changelog::Generator.new(title, type, options.author, options.issue, options["merge-request"], options.amend, options.force)
            generator.execute(options["dry-run"])
        end

        desc 'bundle [VERSION]', 'Bundle the changelogs entry to a new version'
        def bundle_entries; end

        

        default_task :gen_entry

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