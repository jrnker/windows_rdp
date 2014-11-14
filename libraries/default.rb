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

def linfo(data)
        if $showlog == true
                Chef::Log.info(data)
        else
                Chef::Log.debug(data)
        end
end

# Run and return data
def r_d(data_cmd) 
    cmd = Mixlib::ShellOut.new(data_cmd)
    cmd.run_command 
    return cmd.stdout 
end

# Run and return array
def r_a(data_cmd) 
    data = r_d(data_cmd)
    if data != nil
      if data.include? "\n" 
        data = data.split(/\n/)
      else 
        data2 = Array.new
        data2[0] = data.stdout
        data = data2
      end
    end
    return data
end