class repos::centos7 {
	include repos
	file {'/etc/yum.repos.d/centos7.repo':
		source => 'puppet:///modules/repos/centos7.repo',
		owner => 'root',
		mode => '0644'
	} ->
	file {'/tmp/RPM-GPG-KEY-CentOS-7':
		source => 'puppet:///modules/repos/RPM-GPG-KEY-CentOS-7',
	} ~>
	exec { 'install_RPM-GPG-KEY-CentOS-7_key':
		command => "rpm --import /tmp/RPM-GPG-KEY-CentOS-7",
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
		refreshonly => true,
	}
}


