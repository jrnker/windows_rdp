windows_rdp Cookbook
====================
Configures basic RDP connectivity
  
Requirements
------------
Windows. You might want to have windows... 

Attributes
----------
#### windows_rdp::default
 
Key             |&nbsp;&nbsp;&nbsp;&nbsp;|Type|&nbsp;&nbsp;&nbsp;&nbsp;|Description|&nbsp;&nbsp;&nbsp;&nbsp;|Default 
:---------------------------------------||:--------------------------||:-----------------------------------||:-------------
`['windows_rdp']['Configure']`          ||Boolean                    ||Enable RDP configuration            ||false 
`['windows_rdp']['AllowConnections']`   ||String, 'yes' 'no' 'leave' ||Allow RDP connections               ||'yes' 
`['windows_rdp']['AllowOnlyNLA']`       ||String, 'yes' 'no' 'leave' ||Allow only NLA connections          ||'leave' 
`['windows_rdp']['ConfigureFirewall']`  ||String, 'yes' 'no' 'leave' ||Configure Windows Firewall for RDP  ||'yes' 
`['windows_rdp']['AddUsers']`           ||array[tbd]                 ||tbd                                 ||tbd 

 Usage
-----
#### windows_rdp::default

1. Include cookbook in recipe: 
recipe/default.rb
```
include_recipe "windows_rdp"
```
2. Include version in metadata: 
metadata.rb
```
depends 'windows_rdp', '>= 0.1.0'
```
3. Override attributes in your cookbook as needed
```
override['windows_rdp']['Configure']          = true
override['windows_rdp']['AllowConnections']   = 'yes'
override['windows_rdp']['AllowOnlyNLA']       = 'no'
override['windows_rdp']['ConfigureFirewall']  = 'leave' 
```

Todo
----------
* User management

Contributing
------------
 
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
 
License and Authors
-------------------
Authors: Christoffer Järnåker, Proxmea BV

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0