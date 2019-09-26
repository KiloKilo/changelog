require 'optparse'
require 'yaml'
require 'fileutils'
require 'colorize'
require 'changelog/helper'


INVALID_TYPE = -1

module Changelog

  class Generator
    include Changelog::Helper

    def initialize(title, type, author, issue, merge_request, amend, force = false)
      @entry = Changelog::Entry.new(
        parse_title(title), 
        type, 
        parse_author(author), 
        parse_issue(issue), 
        merge_request
      )

      @amend = amend
      @force = force
    end

    def execute(dry_run=false)
      assert_feature_branch!
      assert_title! unless editor
      assert_new_file!

      $stdout.puts "#{'create'.green} #{file_path}"
      $stdout.puts contents

      unless dry_run
        write
        amend_commit if @amend
      end

      if editor
        system("#{editor} '#{file_path}'")
      end
    end

    private

    def contents
      @entry.to_yml
    end

    def write
      dirname = File.dirname(file_path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end

      File.write(file_path, contents)
    end

    def editor
      ENV['EDITOR']
    end

    def amend_commit
      fail_with "git add failed" unless system(*%W[git add #{file_path}])

      Kernel.exec(*%w[git commit --amend])
    end

    def assert_feature_branch!
      return unless branch_name == 'master' and not @force

      fail_with "Create a branch first!"
    end

    def assert_new_file!
      return unless File.exist?(file_path)
      return if @force

      fail_with "#{file_path} already exists! Use `--force` to overwrite."
    end

    def assert_title!
      return if @entry.title.length > 0 || @amend

      fail_with "Provide a title for the changelog entry or use `--amend`" \
        " to use the title from the previous commit."
    end

    def assert_valid_type!
      return unless @entry.type && @entry.type == INVALID_TYPE

      fail_with 'Invalid category given!'
    end

    def parse_title(title)
      return title unless title.empty?
      
      last_commit_subject
    end

    def parse_author(author)
      return author unless author.nil?

      git_user_name
    end

    def parse_issue(issue)
      return issue unless issue.nil?

      issue_nr_from_branch
    end

    def git_user_name
      capture_stdout(%w[git config user.name]).strip
    end

    def last_commit_subject
      capture_stdout(%w[git log --format=%s -1]).strip
    end

    def issue_nr_from_branch
      found = branch_name.scan(/\/?(\d+)-/).first
      found.first unless found.nil?
    end

    def file_path
      base_path = File.join(
        unreleased_path,
        branch_name.gsub(/[^\w-]/, '-'))

      # Add padding for .yml extension
      base_path[0..MAX_FILENAME_LENGTH - 5] + '.yml'
    end

    def unreleased_path
      File.join('changelogs', 'unreleased')
    end

    def branch_name
      @branch_name ||= capture_stdout(%w[git symbolic-ref --short HEAD]).strip
    end

  end
end

# vim: ft=ruby
