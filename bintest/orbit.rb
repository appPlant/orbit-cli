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

require 'open3'
require_relative '../mrblib/orbit/version'

BINARY    = File.expand_path('../mruby/bin/orbit', __dir__)
EMPTY_ENV = ENV.to_h.merge('ORBIT_PATH' => nil).freeze

assert('version') do
  output, status = Open3.capture2(EMPTY_ENV, BINARY, 'version')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_equal output&.chomp, Orbit::VERSION
end

%w[-v --version].each do |flag|
  assert("version [#{flag}]") do
    output, status = Open3.capture2(EMPTY_ENV, BINARY, flag)

    assert_true status.success?, 'Process did not exit cleanly'
    assert_include output, Orbit::VERSION
    assert_not_equal output&.chomp, Orbit::VERSION
  end
end

%w[help -h --help].each do |flag|
  assert("usage [#{flag}]") do
    output, status = Open3.capture2(EMPTY_ENV, BINARY, flag)

    assert_true status.success?, 'Process did not exit cleanly'
    assert_include output, 'Usage'
  end
end

assert('env') do
  output, status = Open3.capture2(BINARY, 'env')

  assert_true status.success?, 'Process did not exit cleanly'

  %w[ORBIT_HOME ORBIT_PATH ORBIT_KEY ORBIT_FILE].each do |env|
    assert_include output, env
    assert_include output, ENV[env].to_s
  end
end

assert('find') do
  output, status = Open3.capture2(BINARY, 'find', 'localhost')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_equal output&.chomp, 'root@localhost'
end

assert('find', 'exit with error') do
  _, output, status = Open3.capture3(BINARY, 'find', 'error')

  assert_false status.success?, 'Process did exit cleanly'
  assert_equal output&.chomp, 'root@localhost'
end

assert('unknown category') do
  _, output, status = Open3.capture3(BINARY, 'unknown')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown category'
end

assert('fifa not in PATH [find]') do
  _, status = Open3.capture2e(EMPTY_ENV, BINARY, 'find')

  assert_false status.success?, 'Process did exit cleanly'
end

assert('plip not in PATH [upload]') do
  _, status = Open3.capture2e(EMPTY_ENV, BINARY, 'upload', 'l', 'r')

  assert_false status.success?, 'Process did exit cleanly'
end

assert('plip not in PATH [download]') do
  _, status = Open3.capture2e(EMPTY_ENV, BINARY, 'download', 'r')

  assert_false status.success?, 'Process did exit cleanly'
end

assert('iss not in PATH [web]') do
  _, status = Open3.capture2e(EMPTY_ENV, BINARY, 'web', 'start')

  assert_false status.success?, 'Process did exit cleanly'
end

assert('alpinepass not in PATH') do
  _, status = Open3.capture2e(EMPTY_ENV, BINARY, 'export')

  assert_false status.success?, 'Process did exit cleanly'
end
