#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

tomcat_tar = File.basename(URI.parse(node['tomcat']['source']).path)
tomxat_dir = tomcat_tar[/apache-tomcat-\d+\.\d+\.\d+/]

package 'java-1.7.0-openjdk' do
  action :remove
end

package 'java-1.8.0-openjdk' do
  action :install
end

package node['tomcat']['java'] do 
  action :install
end

directory node['tomcat']['base_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

remote_file "#{node['tomcat']['base_dir']}/#{tomcat_tar}" do
  source node['tomcat']['source']
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

bash 'untar tomcat' do
  cwd node['tomcat']['base_dir']
  code <<-EOH
    tar -xf #{tomcat_tar}
  EOH
  action :run
  not_if { File.exist?("#{node['tomcat']['base_dir']}/#{tomxat_dir}") }
end

bash 'start tomcat service' do
  cwd "#{node['tomcat']['base_dir']}/#{tomxat_dir}/bin"
  code <<-EOF
    sh startup.sh
  EOF
  action :run
  not_if 'netstat -nlp | grep 8080'
end
