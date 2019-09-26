require 'yaml'
require 'changelog'

module Changelog
	class Entry
		attr_reader :title, :type, :issue, :merge_request, :author

		Type = Struct.new(:name, :description)
		TYPES = [
			Type.new('added', 'New feature'),
			Type.new('fixed', 'Bug fix'),
			Type.new('changed', 'Feature change'),
			Type.new('deprecated', 'New deprecation'),
			Type.new('removed', 'Feature removal'),
			Type.new('security', 'Security fix'),
			Type.new('performance', 'Performance improvement'),
			Type.new('other', 'Other')
		].freeze

		class << self

			def from_yml(path)
				parse_blob(File.read(path))
			end
				
			private
		
			def parse_blob(content) 
				yaml = YAML.safe_load(content)

				Entry.new(yaml['title'], yaml['type'], yaml['author'], yaml['issue'], yaml['merge_request'])
			end
		end


		def initialize(title, type, author, issue, merge_request)
			@title = title
			@type = parse_type(type) 
			@author = author 
			@issue = issue
			@merge_request = merge_request
		end

		def to_s
			str = +""
			str << "#{title}".gsub(/\.{2,}$/, '.')
			str << " ##{issue}" if !issue.nil?
			str << " !#{merge_request}" if !merge_request.nil?
			str << " (#{author})" if !author.nil?

			str
		end

		def valid?
			!@title.nil?
		end

		def to_yml
			yaml_content = YAML.dump(
				'title'         => @title,
				'type'          => @type,
				'issue'         => @issue,
				'merge_request' => @merge_request,
				'author'        => @author,
			)
			remove_trailing_whitespace(yaml_content)
		end

		private

		def parse_type(type)
			TYPES.map(&:name).include?(type) ? type : 'other'
		end

		def remove_trailing_whitespace(yaml_content)
			yaml_content.gsub(/ +$/, '')
		end

	end
end
