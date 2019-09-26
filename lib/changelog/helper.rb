require 'changelog'

module Changelog
    module Helper
        Abort = Class.new(StandardError)
        Done = Class.new(StandardError)

        MAX_FILENAME_LENGTH = 140 # ecryptfs has a limit of 140 characters

        def capture_stdout(cmd)
            output = IO.popen(cmd, &:read)
            fail_with "command failed: #{cmd.join(' ')}" unless $?.success?
            output
        end

        def fail_with(message)
            raise Abort, "\e[31merror\e[0m #{message}"
        end
    end
end