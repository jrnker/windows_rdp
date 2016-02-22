#
# Cookbook Name:: windows_rdp
# Recipe:: default
#
# Copyright 2014, Proxmea BV
#
 
 
if node['windows_rdp']['Configure'] == true 
	$showlog = node['windows_rdp']['ShowLog']
	
	# Get the chef attributes to use
	AllowConnections = node['windows_rdp']['AllowConnections'].downcase
	AllowOnlyNLA = node['windows_rdp']['AllowOnlyNLA'].downcase
	ConfigureFirewall = node['windows_rdp']['ConfigureFirewall'].downcase
	AddUsers = node['windows_rdp']['AddUsers'] 		 
 
	linfo("Chef values:")
	linfo("	AllowConnections #{AllowConnections}")
	linfo("	AllowOnlyNLA #{AllowOnlyNLA}")
	linfo("	ConfigureFirewall #{ConfigureFirewall}")
	linfo("	AddUsers #{AddUsers}")

	# Get the current RDP settings 
	DenyConnectionsHive = "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Terminal Server"
	DenyConnectionsKey = "fDenyTSConnections"
	NLAHive = "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\WinStations\\RDP-Tcp"
	NLAKey = "UserAuthentication"

    DenyConnections = getReg(DenyConnectionsHive,DenyConnectionsKey)
	NLA = getReg(NLAHive,NLAKey) 

	# Get the current firewall settings
	fwrdp = r_a('netsh advfirewall firewall show rule name=all | find /i "Rule Name:" | find /i "Remote Desktop"')

	useExistingRule = false
	useExistingRuleName = ""
	fwRuleActive = false
	fwrdp.each do|name| 
		break if useExistingRule == true  
		data = name.split(":")
		name = data[1].strip!
		fwrule = r_a('netsh advfirewall firewall show rule name="' + name + '"')

		inrule = false
		inport = false
		enabled = false
		fwrule.each do|rule|  
			break if useExistingRule == true
			rule = rule.downcase
			data = rule.split(":")
			if data.count > 1 
				if (data[0].include? "enabled") && (data[1].include? "yes")
					enabled = true
				end 
				if (data[0].include? "direction") && (data[1].include? "in")
					inrule = true
				end 
				if (data[0].include? "localport") && (data[1].include? "3389")
					inport = true
				end 
				if inrule && inport
					useExistingRule = true
					useExistingRuleName = name
					fwRuleActive = enabled 
				end
			end
		end  
	end 
 
	linfo("Actual values:")
	linfo("	DenyConnections #{DenyConnections}")
	linfo("	NLA #{NLA}")
	linfo("	useExistingRule #{useExistingRule}")
	linfo("	useExistingRuleName #{useExistingRuleName}")
	linfo("	fwRuleActive #{fwRuleActive}")

 	if AllowConnections == 'yes' && DenyConnections == 1
 		 Chef::Log.info("Enabling RDP connections")
 	end
	
	registry_key DenyConnectionsHive do
		values [{
			:name => DenyConnectionsKey,
			:type => :dword,
			:data => 0
		}]
		action :create
		only_if {AllowConnections == 'yes' && DenyConnections == 1}
	end

 	if AllowConnections == 'no' && DenyConnections == 0
 		 Chef::Log.info("Disabling RDP connections")
 	end

	registry_key DenyConnectionsHive do
		values [{
			:name => DenyConnectionsKey,
			:type => :dword,
			:data => 1
		}]
		action :create
		only_if {AllowConnections == 'no' && DenyConnections == 0}
	end
	
	
 	if AllowOnlyNLA == 'yes' && NLA == 0
 		 Chef::Log.info("Enforcing NLA for RDP connections")
 	end

	registry_key NLAHive do
		values [{
			:name => NLAKey,
			:type => :dword,
			:data => 1
		}]
		action :create
		only_if {AllowOnlyNLA == 'yes' && NLA == 0}
	end	
	
 	if AllowOnlyNLA == 'no' && NLA == 1
 		 Chef::Log.info("Allowing non-NLA RDP connections")
 	end
	
	registry_key NLAHive do
		values [{
			:name => NLAKey,
			:type => :dword,
			:data => 0
		}]
		action :create
		only_if {AllowOnlyNLA == 'no' && NLA == 1}
	end

	execute 'Enabling firewall RDP connections' do
		command <<-EOH
		netsh advfirewall firewall set rule group="remote desktop" new enable=Yes
		EOH
		only_if {ConfigureFirewall == 'yes' && fwRuleActive == false}
	end
	
	execute 'Disabling firewall RDP connections' do
		command <<-EOH
		netsh advfirewall firewall set rule group="remote desktop" new enable=No
		EOH
		only_if {ConfigureFirewall == 'no' && fwRuleActive == true}
	end	
end