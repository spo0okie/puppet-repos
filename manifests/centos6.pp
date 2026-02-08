class repos::centos6 {
	include repos
	file {'/etc/yum.repos.d/centos6.repo':
		source => 'puppet:///modules/repos/centos6.repo',
		owner => 'root',
		mode => '0644'
	} ->
	file {'/tmp/RPM-GPG-KEY-CentOS-6':
		source => 'puppet:///modules/repos/RPM-GPG-KEY-CentOS-6',
	} ~>
	exec { 'install_RPM-GPG-KEY-CentOS-6_key':
		command => "rpm --import /tmp/RPM-GPG-KEY-CentOS-6",
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
		refreshonly => true,
	}
}


