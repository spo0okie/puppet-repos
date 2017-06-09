class repos::remi {
	include repos
	file {'/etc/yum.repos.d/remi.repo':
		source => 'puppet:///modules/repos/remi.repo',
		owner => 'root',
		mode => '0644'
	} ~>
	exec { 'install_remi_key':
		command => "rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi",
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
		refreshonly => true
	}
}