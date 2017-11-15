
directory 'C:\apache' do
  mode 0755
  recursive true
  action :create
end

remote_file 'C:\apache\httpd-2.2.34-win32-src.zip' do
  source node['apache']['win_pkg']
  mode 0755
  action :create
end

windows_zipfile 'C:\apache\httpd-2.2.34-win32-src' do
  source 'C:\apache\httpd-2.2.34-win32-src.zip'
  action :unzip
end
