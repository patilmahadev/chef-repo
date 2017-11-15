#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

admins = data_bag_item('sysadmins', 'bob')

user admins['id'] do
  uid admins['uid']
  shell admins['shell']
  comment admins['comment']
  action :create
end

if node['platform_family'] == 'amazon'
  include_recipe 'apache::amazon'

elsif node['platform_family'] == 'debian'
  include_recipe 'apache::debian'

elsif node['platform_family'] == 'windows'
  include_recipe 'apache::windows'

else
  puts "This cookbook is not supported on #{node['platform_family']}."
end


