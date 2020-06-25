class repos::zabbix {
	case $::operatingsystem {
		'CentOS': {
			#тут у нас старый репозиторий мог быть, который мы прям файлом закидывали. его надо убирать
			file {"zabbix32_repo_repo(old)":
				path => "/etc/yum.repos.d/zabbix32_repo.repo",
				ensure => absent,
			} ->
			#а ставить надо прям с сайта заббикса
			exec {"install_zabbix_repo":
				command => "yum install https://repo.zabbix.com/zabbix/4.0/rhel/${::operatingsystemmajrelease}/x86_64/zabbix-release-4.0-1.el${::operatingsystemmajrelease}.noarch.rpm -y",
				unless => "rpm -qa | grep zabbix-release-4",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			} 
		}
	}
}
