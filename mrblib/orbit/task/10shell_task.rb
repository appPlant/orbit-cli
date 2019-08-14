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
    class ShellTask
      # Spawn a process with the specified args.
      #
      # @param [ String ] bin The name of the binary tool.
      # @param [ Array<String> ] args List of arguments.
      # @param [ Array<String> ] blacklist: Non-default disallowed flags.
      #
      # @return [ Int ] The ID of the spawned process.
      def spawn(bin, *args, blacklist: nil)
        raise_if_blacklisted(args, blacklist)
        Process.spawn ENV.to_hash, binpath(bin), *args
      rescue SystemCallError
        abort "command not found: #{bin}", 127
      end

      # Replace the process by running the given external command.
      #
      # @param [ String ] bin The name of the binary tool.
      # @param [ Array<String> ] args List of arguments.
      # @param [ Array<String> ] blacklist: Non-default disallowed flags.
      #
      # @return [ Void ]
      def exec(bin, *args, blacklist: nil)
        raise_if_blacklisted(args, blacklist)
        Process.exec ENV.to_hash, binpath(bin), *args
      rescue SystemCallError
        abort "command not found: #{bin}", 127
      end

      # Kill the process.
      #
      # @param [ Int ] pid The ID of the process to kill.
      #
      # @return [ Void ]
      def kill(pid)
        Process.kill(OS.windows? ? :KILL : :TERM, pid.to_i)
      rescue SystemCallError
        # nothing to do
      end

      # Waits for a child process to exit.
      #
      # @param [ Int ] pid The ID of the process to kill.
      #
      # @return [ Process::Status ]
      def wait(pid, attempts: 2500)
        attempts.times { return $? if Process.wait(pid, Process::WNOHANG) && $? } && $?
      rescue SystemCallError
        # nothing to do
      end

      private

      # Raises a runtime error if args includes a blacklisted flag.
      #
      # @param [ Array<String> ] args List of arguments.
      # @param [ Array<String> ] blacklist Non-default disallowed flags.
      #
      # @return [ Void ]
      def raise_if_blacklisted(args, blacklist)
        flags = %w[-h -v --help --version]
        flags.concat(blacklist) if blacklist

        flag = args.find { |arg| flags.include? arg }

        raise "unsupported option: #{flag}" if flag
      end

      # The path of the binary. If ORBIT_BIN is defined, it is expected to be
      # found under that path. Otherwise it should be available through PATH.
      #
      # @param [ String ] bin The name of the binary tool.
      #
      # @return [ String ]
      def binpath(bin)
        path = ENV.include?('ORBIT_BIN') ? "#{ENV['ORBIT_BIN']}/#{bin}" : bin
        path = path + '.exe' if OS.windows?
        path
      end
    end
  end
end
