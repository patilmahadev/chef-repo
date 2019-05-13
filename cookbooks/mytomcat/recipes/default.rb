#
# Cookbook:: mytomcat
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

mytomcat 'tomcat' do
  tar_url 'http://mirrors.estointernet.in/apache/tomcat/tomcat-9/v9.0.19/bin/apache-tomcat-9.0.19.tar.gz'
  installation_dir '/opt'
  action :install
end

mytomcat 'tomcat' do
  tar_url 'http://mirrors.estointernet.in/apache/tomcat/tomcat-9/v9.0.19/bin/apache-tomcat-9.0.19.tar.gz'
  action :start
end

