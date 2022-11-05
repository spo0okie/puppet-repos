class repos::zabbix {

	case $::operatingsystem {
#Debian и Ubuntu согласно инструкции:
#https://www.zabbix.com/documentation/4.4/ru/manual/installation/install_from_packages/debian_ubuntu
		'Debian': {
			case $::operatingsystemmajrelease {
				'11': {
					$packagename='zabbix-release_6.2-1+debian11_all'
				}
				'10':  {
					$packagename='zabbix-release_6.2-1+debian10_all'
				}
				'9':  {
					$packagename='zabbix-release_6.2-1+debian9_all'
				}
			} 
			file {"/tmp/$packagename.deb":
				source => "puppet:///modules/repos/zabbix/$packagename.deb",
			} ~>
			exec {"install_zabbix_repo":
				command => "dpkg -i /tmp/$packagename.deb && apt update",
				unless => "dpkg -l | grep zabbix-release | grep 6.2",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			}

		}


		'Ubuntu': {
			case $::operatingsystemmajrelease {
				'22.04': {
					$packagename='zabbix-release_6.2-1+ubuntu22.04_all'
				}
				'20.04': {
					$packagename='zabbix-release_6.2-1+ubuntu20.04_all'
				}
				'18.04':  {
					$packagename='zabbix-release_6.2-1+ubuntu18.04_all'
				}
				'16.04':  {
					$packagename='zabbix-release_6.2-1+ubuntu16.04_all'
				}
				'14.04':  {
					$packagename='zabbix-release_6.2-1+ubuntu14.04_all'
				}
			} 
			file {"/tmp/$packagename.deb":
				source => "puppet:///modules/repos/zabbix/$packagename.deb",
			} ~>
			exec {"install_zabbix_repo":
				command => "dpkg -i /tmp/$packagename.deb && apt update",
				unless => "dpkg -l | grep zabbix-release | grep 6.2",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			}
		}
	}
}
