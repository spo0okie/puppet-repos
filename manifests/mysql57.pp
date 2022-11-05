class repos::mysql57 {
	case $::operatingsystem {
		'CentOS': {
			exec {"install_mysql57_repo":
				command => "rpm -i http://repo.mysql.com/mysql57-community-release-el${::operatingsystemmajrelease}.rpm",
				unless => "rpm -qa | grep mysql57-community-release",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			}
		}
	}
}


