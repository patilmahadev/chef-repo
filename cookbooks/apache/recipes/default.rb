#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['platform_family'] == 'amazon'
  include_recipe 'apache::amazon'

elsif node['platform_family'] == 'debian'
  include_recipe 'debian'

else
  puts "This cookbook is not supported on #{node['platform_family']}."
end


