require 'changelog/semantic_version'
require 'active_support/core_ext/string'

module Changelog

    class MarkdownGenerator
        attr_reader :version, :entries

        def initialize(version, entries, include_date: false)
            @version = version
            @entries = entries.select(&:valid?)
            @include_date = include_date
        end

        def to_s
            markdown = StringIO.new
            markdown.puts header
            markdown.puts

            if entries.empty?
                markdown.puts "-   No changes.\n\n"
            else
                markdown.puts formatted_entries
            end

            markdown.string
        end

        private

        def header
            head = "## #{version.to_patch}"
            head += " (#{date})" if @include_date
            head
        end

        def date
            Date.today.strftime("%Y-%m-%d")
        end

        def entries_grouped_by_type(type) 
            entries.select { |entry| entry.type == type }
        end

        # Group entries by type found in the `Changelog::Entry::TYPES`.
        # Output example:
        #
        # ### Fixed (52 changes)
        # - Fix 404 errors in API caused when the branch name had a dot. #42 !14462 (ajoly)
        def formatted_entries
            result = +''

            Changelog::Entry::TYPES.map(&:name).each do |type|
                grouped_entries = entries_grouped_by_type(type)
                changes_count = grouped_entries.size

                # Do nothing if no changes are presented for the current type.
                next unless changes_count.positive?

                # Prepare the group header.
                # Example:
                # ### Added (54 changes)
                changes = [changes_count, 'change'.pluralize(changes_count)].join("\s")

                result << "### #{type.capitalize} (#{changes})\n\n"

                # Add entries to the group.
                grouped_entries.each { |entry| result << "-   #{entry}\n" }

                result << "\n"
            end
            
            result
        end
    end
end

