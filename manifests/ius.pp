class repos::ius {
	case $::operatingsystem {
		'CentOS': {
			exec {"install_ius_repo":
				command => "rpm -i http://repo.ius.io/ius-release-el${::operatingsystemmajrelease}.rpm",
				unless => "rpm -qa | grep ius-release",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			} #~>
			#exec {"install_ius_key":
			#	command => 'rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
			#	path => '/bin:/sbin:/usr/bin:/usr/sbin',
			#	refreshonly => true,
			#}
		}
	}
}


