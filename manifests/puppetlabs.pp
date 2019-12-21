class repos::puppetlabs {
	case $::operatingsystem {
		'CentOS': {
			exec {'install_puppetlabs_repo':
				command => "rpm -i http://yum.puppetlabs.com/puppet-release-el-${::operatingsystemmajrelease}.noarch.rpm",
				unless => "rpm -qa | grep puppet-release",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			} ~>
			exec {'install_puppetlabs_key':
				command => 'rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
				refreshonly => true,
			}
		}
	}
}


