resource_name :mytomcat

property :tomcat_name, String, name_property: true
property :tar_url, String, required: true
property :installation_dir, String, default: '/opt'

action :install do

  tomcat_tar = ::File.basename(URI.parse(new_resource.tar_url).path)
  tomcat_dir = tomcat_tar[/apache-tomcat-\d+\.\d+\.\d+/]

  package 'java-1.7.0-openjdk' do
    action :remove
  end

  package 'java-1.8.0-openjdk' do
    action :install
  end

  directory new_resource.installation_dir do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end 

  remote_file "#{new_resource.installation_dir}/#{tomcat_tar}" do
    source new_resource.tar_url
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end 

  bash 'untar tomcat' do
    cwd new_resource.installation_dir
    code <<-EOH
      tar -xf #{tomcat_tar}
    EOH
    action :run
    not_if { ::File.exist?("#{new_resource.installation_dir}/#{tomcat_dir}") }
  end

end

action :delete do

  require 'fileutils'

  tomcat_tar = ::File.basename(URI.parse(new_resource.tar_url).path)
  tomcat_dir = tomcat_tar[/apache-tomcat-\d+\.\d+\.\d+/]

  bash 'stop tomcat service' do
    cwd "#{new_resource.installation_dir}/#{tomcat_dir}/bin"
    code <<-EOF
      sh shutdown.sh
    EOF
    action :run
    only_if 'netstat -nlp | grep 8080'
  end

  FileUtils.rm_rf("#{new_resource.installation_dir}/#{tomcat_dir}")
  FileUtils.rm_rf("#{new_resource.installation_dir}/#{tomcat_tar}")

end

action :start do

  tomcat_tar = ::File.basename(URI.parse(new_resource.tar_url).path)
  tomcat_dir = tomcat_tar[/apache-tomcat-\d+\.\d+\.\d+/]

  bash 'start tomcat service' do
    cwd "#{new_resource.installation_dir}/#{tomcat_dir}/bin"
    code <<-EOF
      sh startup.sh
    EOF
    action :run
    not_if 'netstat -nlp | grep 8080'
  end
  sleep(20)
end

action :stop do

  tomcat_tar = ::File.basename(URI.parse(new_resource.tar_url).path)
  tomcat_dir = tomcat_tar[/apache-tomcat-\d+\.\d+\.\d+/]

  bash 'stop tomcat service' do
    cwd "#{new_resource.installation_dir}/#{tomcat_dir}/bin"
    code <<-EOF
      sh shutdown.sh
    EOF
    action :run
    only_if 'netstat -nlp | grep 8080'
  end
  sleep(20)
end

action :restart do

  tomcat_tar = ::File.basename(URI.parse(new_resource.tar_url).path)
  tomcat_dir = tomcat_tar[/apache-tomcat-\d+\.\d+\.\d+/]

  bash 'stop tomcat service' do
    cwd "#{new_resource.installation_dir}/#{tomcat_dir}/bin"
    code <<-EOF
      sh shutdown.sh
    EOF
    action :run
    only_if 'netstat -nlp | grep 8080'
  end

  sleep(20)
  bash 'start tomcat service' do
    cwd "#{new_resource.installation_dir}/#{tomcat_dir}/bin"
    code <<-EOF
      sh startup.sh
    EOF
    action :run
    not_if 'netstat -nlp | grep 8080'
  end

end
