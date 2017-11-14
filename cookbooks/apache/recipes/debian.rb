#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'apache2' do
  action :install
end

template "#{node['apache']['doc_root']}/#{node['apache']['index']}" do
  source 'test.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    :os => node['os'],
    :platform_family => node['platform_family'],
    :pri_ip => node['ipaddress'],
    :pub_ip => node['ec2']['public_ipv4']
  )
  action :create
end

service 'apache2' do
  action [:enable, :start]
end
