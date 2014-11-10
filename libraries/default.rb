#
# Cookbook Name:: windows_network
# Recipe:: default
#
# Copyright 2014, Proxmea BV
#

# Type of registry keys are:
# :binary for REG_BINARY
# :string for REG_SZ
# :multi_string for REG_MULTI_SZ
# :expand_string for REG_EXPAND_SZ
# :dword for REG_DWORD
# :dword_big_endian for REG_DWORD_BIG_ENDIAN
# :qword for REG_QWORD

def setReg(hive,key,type,data)  
      registry_key hive do
        values [{
          :name => key,
          :type => type ,
          :data => data
          }]
          action :create 
      end
end

def getReg(hive,key)
	return registry_get_values(hive).find_all{|item| item[:name] == key}[0][:data]
end