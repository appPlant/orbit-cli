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
  module TaskRunner
    # Find out and run the task as specified.
    #
    # @param [ Array<String> ] args The command-line args.
    #
    # @return [ Void ]
    def self.run(args)
      create_task(args[0]).run(args[1..-1])
    end

    # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength

    # Find the task class by keyword name.
    #
    # @param [ String ] name The name of the task (find, exec, ...)
    #
    # @return [ Orbit::Task::BaseTask ]
    def self.create_task(name)
      case name
      when nil, 'help', '-h', '--help'
        Task::HelpTask.new
      when 'version'
        Task::VersionTask.new
      when '-v', '--version'
        Task::VersionTask.new(true)
      when 'env'
        Task::EnvTask.new
      when 'find'
        Task::FindTask.new
      when 'web'
        Task::WebTask.new
      when 'exec'
        Task::ExecTask.new
      when 'upload'
        Task::UploadTask.new
      when 'download'
        Task::DownloadTask.new
      when 'export'
        Task::ExportTask.new
      when 'docker'
        Task::DockerTask.new
      else
        raise "unknown category: #{name}"
      end
    end

    # rubocop:enable AbcSize, CyclomaticComplexity, MethodLength
  end
end
