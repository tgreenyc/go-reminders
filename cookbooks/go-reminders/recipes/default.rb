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
     :etcd_host => node['go-reminders']['etcdhost'],
     :etcd_port => node['go-reminders']['etcdport'],
  }) 
end

service "go-reminders" do
  action :start
end
