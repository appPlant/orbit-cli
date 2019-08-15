# Apache 2.0 License
#
# Copyright (c) 2016 Sebastian Katzer, appPlant GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

module Orbit
  module Task
    class ExecTask < ShellTask
      # Invokes ski with the specified args.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def run(args)
        case args[0]
        when 'script' then exec_script(args[1..-1])
        when 'job'    then exec_job(args[1..-1])
        else exec_command(args)
        end
      end

      private

      # Execute the command.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def exec_command(args)
        raise 'no command given' unless args.any?

        exec 'ski', '-c', *args, blacklist: %w[-s --script -j --job]
      end

      # Execute the script.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def exec_script(args)
        raise 'no script given' unless args.any?

        exec 'ski', '-s', *args, blacklist: %w[-c --command -j --job]
      end

      # Execute the job.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def exec_job(args)
        raise 'no job given' unless args.any?

        exec 'ski', '-j', *args, blacklist: %w[-s --script -c --command]
      end
    end
  end
end
