class repos::zabbix {
	case $::operatingsystem {
		'CentOS': {
			exec {"install_zabbix_repo":
				command => "yum install https://repo.zabbix.com/zabbix/4.0/rhel/${::operatingsystemmajrelease}/x86_64/zabbix-release-4.0-1.el${::operatingsystemmajrelease}.noarch.rpm -y",
				unless => "rpm -qa | grep zabbix-release-4.0",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			} 
		}
	}
}
