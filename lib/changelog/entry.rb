module Changelog
  class Entry

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

  end
end
