#
# Cookbook Name:: go-reminders
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'artifactory-artifact'

directory "/usr/local/go-reminders" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

artifactory_artifact "/usr/local/go-reminders/go-reminders" do
  artifactory_url "http://#{node['go-reminders']['artifactory']['server']}/artifactory"
  artifactory_username node['go-reminders']['artifactory']['username']
  artifactory_password node['go-reminders']['artifactory']['password']
  repository "go-reminders"
  repository_path "go-reminders"
  mode "0755"
end

template "/etc/init/go-reminders.conf" do
  source "go-reminders.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
     :db_host => node['go-reminders']['db_host'],
     :db_port => node['go-reminders']['db_port'],
     :db_user => node['go-reminders']['db_user'],
     :db_passwd => node['go-reminders']['db_passwd'],
  }) 
  notifies :restart, 'service[go-reminders]'
end

service "go-reminders" do
  action :start
end
