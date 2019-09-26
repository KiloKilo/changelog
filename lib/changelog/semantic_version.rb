module Changelog
    class SemanticVersion < String
    
        VERSION_REGEX = %r{
            \A(?<major>\d+)
            \.(?<minor>\d+)
            (\.(?<patch>\d+))?
            \z
            }x.freeze

        def initialize(version_string)
            super(version_string)

            if valid? && extract_from_version(:patch, fallback: nil).nil?
                super(to_patch)
            end
        end

        def ==(other)
            if other.respond_to?(:to_patch)
                to_patch.eql?(other.to_patch)
            else
                super
            end
        end

        def <=>(other)
            return nil unless other.is_a?(SemanticVersion)
            return 0 if self == other

            if major > other.major ||
                (major >= other.major && minor > other.minor) ||
                (major >= other.major && minor >= other.minor && patch > other.patch)
                1
            else
                -1
            end
        end

        def major
            @major ||= extract_from_version(:major).to_i
        end

        def minor
            @minor ||= extract_from_version(:minor).to_i
        end

        def patch
            @patch ||= extract_from_version(:patch).to_i
        end

        def to_minor
            "#{major}.#{minor}"
        end
        
        def to_patch
            "#{major}.#{minor}.#{patch}"
        end


        def valid?
            self.class::VERSION_REGEX.match?(self)
        end

        private 

        def extract_from_version(part, fallback: 0)
            match_data = self.class::VERSION_REGEX.match(self)
            if match_data && match_data.names.include?(part.to_s) && match_data[part]
                String.new(match_data[part])
            else
                fallback
            end
        end

    end
end