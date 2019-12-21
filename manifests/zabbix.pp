class repos::zabbix {
	case $::operatingsystem {
		'CentOS': {
			exec {"install_zabbix_repo":
				command => "yum install http://repo.zabbix.com/zabbix/4.0/rhel/${::operatingsystemmajrelease}/zabbix-release-4.0.el${::operatingsystemmajrelease}.noarch.rpm -y",
				unless => "rpm -qa | grep zabbix-release-4.0",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			} 
		}
	}
}
