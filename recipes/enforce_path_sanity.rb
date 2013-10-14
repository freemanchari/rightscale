# Cookbook Name:: rightscale
# Recipe:: enforce_path_sanity
#
# Copyright 2012, Chris Fordham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# adds path sanity and the rightlink sandbox to ENV['PATH']

if node['rightscale']['enforce_path_sanity'] == 'true'
  r = ruby_block "enforce path sanity" do
    block do
      # derived from https://github.com/opscode/chef/blob/master/lib/chef/client.rb
      if RUBY_PLATFORM !~ /mswin|mingw32|windows/
        SANE_PATHS = %w[/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin]
        env = ENV
        existing_paths = env["PATH"].split(':')
        SANE_PATHS.each do |sane_path|
          unless existing_paths.include?(sane_path)
            env_path = env["PATH"].dup
            env_path << ':' unless env["PATH"].empty?
            env_path << sane_path
            env["PATH"] = env_path
          end
        end
        ENV['PATH'] = env['PATH']
      end
    end
    action :nothing
  end
  r.run_action(:create)
end