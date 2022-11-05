class repos::remi {
	case $::operatingsystem {
		'CentOS': {
			include repos
			exec { 'install_remi_repo':
					command => "rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-${::operatingsystemmajrelease}.rpm",
					path => '/bin:/sbin:/usr/bin:/usr/sbin',
					unless => 'ls -1 /etc/yum.repos.d | grep remi'
				} ->
				exec { 'install_remi_key':
					command => "rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi",
					path => '/bin:/sbin:/usr/bin:/usr/sbin',
					refreshonly => true
				}
		}
	}
}
