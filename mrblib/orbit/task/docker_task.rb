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
    class DockerTask < ShellTask
      # Docker utility tasks.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def run(args)
        case args[0]
        when 'build' then build(args[1..-1])
        when 'start' then start(args[1..-1])
        when 'stop'  then stop(args[1..-1])
        else raise "unknown category #{args[0]}"
        end
      end

      private

      # Build image.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def build(args)
        docker 'build', '-t', 'orbit', *args, '.' unless docker_compose?
      end

      # Start container.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def start(args)
        if docker_compose?
          docker_compose 'up', '-d', *args, 'orbit'
        else
          docker 'run', '--rm', '--name', 'orbit', '-d', '-v', "#{orbit_home}:/home/orbit", '-w', '/home/orbit', '-p', '1974:1974', *args, 'orbit'
        end
      end

      # Stop container.
      #
      # @param [ Array<String> ] args List of task arguments.
      #
      # @return [ Void ]
      def stop(args)
        if docker_compose?
          docker_compose 'down', *args
        else
          docker 'stop', *args, 'orbit'
        end
      end

      # Execute docker with the given arguments.
      #
      # @param [ Array<String> ] *args List of arguments.
      #
      # @return [ Void ]
      def docker(*args)
        chdir_orbit { exec 'docker', *args }
      end

      # Execute docker-compose with the given arguments.
      #
      # @param [ Array<String> ] *args List of arguments.
      #
      # @return [ Void ]
      def docker_compose(*args)
        chdir_orbit { exec 'docker-compose', *args }
      end

      # If the docker-compose.yml file should be used instead.
      #
      # @return [ Boolean ]
      def docker_compose?
        File.exist? "#{orbit_home}/docker-compose.yml"
      end
    end
  end
end
