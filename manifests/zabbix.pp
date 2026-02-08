class repos::zabbix {

	case $::operatingsystem {
#Debian и Ubuntu согласно инструкции:
#https://www.zabbix.com/documentation/4.4/ru/manual/installation/install_from_packages/debian_ubuntu
		'Debian': {
			case $::operatingsystemmajrelease {
				'12': {
					$packagename='zabbix-release_7.0-2+debian12_all'
				}
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

		'SLES': {
			case $::operatingsystemmajrelease {
				'15': {
					$packagename='zabbix-release-6.2-2.sles15.noarch'
				}
			}
			file {"/tmp/$packagename.rpm":
				source => "puppet:///modules/repos/zabbix/$packagename.rpm",
			} ~>
			exec {"install_zabbix_repo":
				command => "rpm -Uvh --nosignature /tmp/$packagename.rpm && zypper --gpg-auto-import-keys refresh",
				unless => "rpm -qa | grep zabbix-release | grep 6.2",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			}
		}

		'RedHat': {
			case $::operatingsystemmajrelease {
				'6': {
					$packagename='zabbix-release-6.0-4.el6.noarch'
				}
				'7': {
					$packagename='zabbix-release-6.0-4.el7.noarch'
				}
			}
			file {"/tmp/$packagename.rpm":
				source => "puppet:///modules/repos/zabbix/$packagename.rpm",
			} ~>
			exec {"install_zabbix_repo":
				command => "rpm -Uvh --nosignature /tmp/$packagename.rpm",
				unless => "rpm -qa | grep zabbix-release | grep 6.0",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			}
		}
	}
}
