#
# Cookbook Name:: windows_rdp
# Recipe:: default
#
# Copyright 2014, Proxmea BV
#

default['windows_rdp']['Configure']         = true
default['windows_rdp']['ShowLog']           = false

# Configuration options below are 'yes','no' and 'leave'. The latter won't configure the option.
default['windows_rdp']['AllowConnections']  = 'yes'
default['windows_rdp']['AllowOnlyNLA']      = 'leave'
default['windows_rdp']['ConfigureFirewall']	= 'yes'
default['windows_rdp']['AddUsers']          = []
