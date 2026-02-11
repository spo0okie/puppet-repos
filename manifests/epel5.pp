class repos::epel5 {
	include repos
	file {'/etc/yum.repos.d/epel5.repo':
		source => 'puppet:///modules/repos/epel5.repo',
		owner => 'root',
		mode => '0644'
	}
}


