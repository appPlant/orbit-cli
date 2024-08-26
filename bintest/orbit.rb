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
DUMMY_ENV = ENV.to_h.merge('ORBIT_BIN' => __dir__).freeze

assert('version') do
  output, status = Open3.capture2(BINARY, 'version')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_equal output&.chomp, Orbit::VERSION
end

%w[-v --version].each do |flag|
  assert("version [#{flag}]") do
    output, status = Open3.capture2(BINARY, flag)

    assert_true status.success?, 'Process did not exit cleanly'
    assert_include output, Orbit::VERSION
    assert_not_equal output&.chomp, Orbit::VERSION
  end
end

%w[help -h --help].each do |flag|
  assert("usage [#{flag}]") do
    output, status = Open3.capture2(BINARY, flag)

    assert_true status.success?, 'Process did not exit cleanly'
    assert_include output, 'Usage'
  end
end

assert('env') do
  output, status = Open3.capture2(BINARY, 'env')

  assert_true status.success?, 'Process did not exit cleanly'

  %w[ORBIT_HOME ORBIT_BIN ORBIT_KEY ORBIT_FILE].each do |env|
    assert_include output, env
    assert_include output, ENV[env].to_s
  end
end

%w[unknown web web\ unknown docker docker\ unknown].each do |category|
  assert('unknown category', category) do
    _, output, status = Open3.capture3(BINARY, *category.split)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, 'unknown category'
  end
end

assert('find') do
  output, status = Open3.capture2e(BINARY, 'find', 'localhost')

  skip('missing mock') if ENV['OS'] == 'Windows_NT'

  assert_true status.success?, 'Process did not exit cleanly'
  assert_equal output&.chomp, 'root@localhost'
end

assert('find', 'exit with error') do
  _, output, status = Open3.capture3(BINARY, 'find', 'error')

  skip('missing mock') if ENV['OS'] == 'Windows_NT'

  assert_false status.success?, 'Process did exit cleanly'
  assert_equal output&.chomp, 'root@localhost'
end

assert('find', 'fifa not found') do
  _, output, status = Open3.capture3(DUMMY_ENV, BINARY, 'find')

  assert_equal 127, status.exitstatus
  assert_include output, "command not found: #{DUMMY_ENV['ORBIT_BIN']}/fifa"
end

assert('upload', 'plip not found') do
  _, output, status = Open3.capture3(BINARY, 'upload', 's', 't')

  assert_equal 127, status.exitstatus
  assert_include output, "command not found: #{ENV['ORBIT_BIN']}/plip"
end

assert('upload', 'no source given') do
  _, output, status = Open3.capture3(BINARY, 'upload')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'no source given'
end

assert('upload', 'no target given') do
  _, output, status = Open3.capture3(BINARY, 'upload', 'source')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'no target given'
end

%w[-d --download].each do |flag|
  assert('upload', "unsupported option [#{flag}]") do
    _, output, status = Open3.capture3(BINARY, 'upload', 's', 't', flag)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, "unsupported option: #{flag}"
  end
end

assert('download', 'plip not found') do
  _, output, status = Open3.capture3(BINARY, 'download', 'file')

  assert_equal 127, status.exitstatus
  assert_include output, "command not found: #{ENV['ORBIT_BIN']}/plip"
end

assert('download', 'no file given') do
  _, output, status = Open3.capture3(BINARY, 'download')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'no file given'
end

%w[-u --uid -g --gid -m --mode].each do |flag|
  assert('download', "unsupported option [#{flag}]") do
    _, output, status = Open3.capture3(BINARY, 'download', 'file', flag)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, "unsupported option: #{flag}"
  end
end

assert('web start', 'iss not found') do
  output, status = Open3.capture2e(BINARY, 'web', 'start')

  assert_equal 127, status.exitstatus
  assert_include output, "command not found: #{ENV['ORBIT_BIN']}/iss"
end

%w[-r --routes].each do |flag|
  assert('web start', "unsupported option [#{flag}]") do
    _, output, status = Open3.capture3(BINARY, 'web', 'start', flag)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, "unsupported option: #{flag}"
  end
end

['exec', 'exec script', 'exec job'].each do |category|
  assert(category, 'iss not found') do
    _, output, status = Open3.capture3(BINARY, *category.split, '1')

    assert_equal 127, status.exitstatus
    assert_include output, "command not found: #{ENV['ORBIT_BIN']}/ski"
  end

  sub_category = category.split[1] || 'command'

  assert(category, "no #{sub_category} given") do
    _, output, status = Open3.capture3(BINARY, *category.split)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, "no #{sub_category} given"
  end
end

%w[-s --script -j --job].each do |flag|
  assert('exec', "unsupported option [#{flag}]") do
    _, output, status = Open3.capture3(BINARY, 'exec', '1', flag)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, "unsupported option: #{flag}"
  end
end

%w[-c --command -j --job].each do |flag|
  assert('exec script', "unsupported option [#{flag}]") do
    _, output, status = Open3.capture3(BINARY, 'exec', 'script', '1', flag)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, "unsupported option: #{flag}"
  end
end

%w[-s --script -c --command].each do |flag|
  assert('exec job', "unsupported option [#{flag}]") do
    _, output, status = Open3.capture3(BINARY, 'exec', 'job', '1', flag)

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, "unsupported option: #{flag}"
  end
end

assert('export', 'alpinepass not found') do
  _, output, status = Open3.capture3(BINARY, 'export', 'file')

  assert_equal 127, status.exitstatus
  assert_include output, "command not found: #{ENV['ORBIT_BIN']}/alpinepass"
end

assert('export', 'no file given') do
  _, output, status = Open3.capture3(BINARY, 'export')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'no file given'
end
