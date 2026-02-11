class repos::centos5 {
	include repos
	file {'/etc/yum.repos.d/centos5.repo':
		source => 'puppet:///modules/repos/centos5.repo',
		owner => 'root',
		mode => '0644'
	}
}


