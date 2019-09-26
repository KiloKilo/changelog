require 'yaml'
require 'changelog'

module Changelog
  class Entry
    attr_reader :title, :type

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


    def initialize(title, type, author, issue, merge_request)
      @title = title
      @type = parse_type(type) 
      @author = author 
      @issue = issue
      @merge_request = merge_request
    end

    def valid?
      title.present?
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
