require 'yaml'
require 'changelog/markdown_generator'
require 'changelog/updater'
require 'colorize'

module Changelog

	class Bundler
		include Changelog::Helper
		
		def initialize(version, changelog_file, include_date = false, no_commit = false, dry_run = false, force = false)
			@version = version
			@changelog_file = changelog_file || 'CHANGELOG.md'
			@include_date = include_date
			@unreleased_entries = nil
			@no_commit = no_commit
			@dry_run = dry_run
			@force = force
		end

		def execute
			assert_entries!

			update_changelog

			delete_file_entries

			commit_changes unless @no_commit || @dry_run
		end

		private

		def update_changelog
			markdown = Changelog::MarkdownGenerator.new(@version, unreleased_entries, include_date: @include_date).to_s

			updater = Updater.new(@changelog_file, @dry_run)
			updater.insert(@version, markdown)

		end

		def commit_changes
			success = Kernel.system("git add #{@changelog_file} #{unreleased_path}")
			success &&= Kernel.system("git commit -m \"🧾 Update #{@changelog_file} for v#{@version.to_patch}\n\n[ci skip]\"")

			fail_with "Files could not be commited" unless success
		end

		def unreleased_entries
			return @unreleased_entries if @unreleased_entries

			@unreleased_entries = []

			unreleased_paths.each do |fname|		
				@unreleased_entries << Entry.from_yml(fname)
			end

			@unreleased_entries
		end

		def unreleased_path
			File.join('changelogs', 'unreleased')
		end

		def unreleased_paths
			Dir.glob(File.join(unreleased_path, '*.yml'))
		end

		def delete_file_entries
			unreleased_paths.each do |path|
				if @dry_run
					$stdout.puts "#{'delete'.red} #{path}"
					next
				end

				File.delete(path) if File.exist?(path)

			end
		end

		def assert_entries!
			return if unreleased_entries.length > 0
			return if @force

			fail_with "No entries in '#{unreleased_path}' available! Use `--force` to write an empty version."
		end
		
	end
end


# vim: ft=ruby
