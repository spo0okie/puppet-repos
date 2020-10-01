class repos::zabbix {
	case $::operatingsystem {
		'CentOS': {
			exec {"install_zabbix_repo":
				command => "yum install https://repo.zabbix.com/zabbix/4.4/rhel/${::operatingsystemmajrelease}/x86_64/zabbix-release-4.4-1.el${::operatingsystemmajrelease}.noarch.rpm -y",
				unless => "rpm -qa | grep zabbix-release-4.4",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			} 
		}

#Debian и Ubuntu согласно инструкции:
#https://www.zabbix.com/documentation/4.4/ru/manual/installation/install_from_packages/debian_ubuntu
		'Debian': {
			case $::operatingsystemmajrelease {
				'10': {
					$packagename='zabbix-release_4.4-1+buster_all'
				}
				'9':  {
					$packagename='zabbix-release_4.4-1+stretch_all'
				}
				'8':  {
					$packagename='zabbix-release_4.4-1+jessie_all'
				}
			} 
			exec {"download_zabbix_repo":
				command => "wget https://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/$packagename.deb",
				unless => "test -f /tmp/$packagename.deb",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			} ->
			exec {"install_zabbix_repo":
				command => "dpkg -i /tmp/$packagename.deb && apt update",
				unless => "dpkg -l | grep zabbix-release | grep 4.4",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			}

		}


		'Ubuntu': {
			case $::operatingsystemmajrelease {
				'20.04': {
					$packagename='zabbix-release_4.4-1+focal_all'
				}
				'18.04':  {
					$packagename='zabbix-release_4.4-1+bionic_all'
				}
				'16.04':  {
					$packagename='zabbix-release_4.4-1+xenial_all'
				}
				'14.04':  {
					$packagename='zabbix-release_4.4-1+trusty_all'
				}
			} 
			exec {"download_zabbix_repo":
				command => "wget https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/$packagename.deb",
				unless => "test -f /tmp/$packagename.deb",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			} ->
			exec {"install_zabbix_repo":
				command => "dpkg -i /tmp/$packagename.deb && apt update",
				unless => "dpkg -l | grep zabbix-release | grep 4.4",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				cwd => '/tmp',
			}
		}
	}
}
