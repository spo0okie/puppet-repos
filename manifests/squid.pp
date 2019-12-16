class repos::squid {
	case $::operatingsystem {
		CentOS: {
			exec {"install_squid_repo":
				command => "yum install http://ngtech.co.il/repo/centos/${::operatingsystemmajrelease}/squid-repo-1-1.el${::operatingsystemmajrelease}.centos.noarch.rpm -y",
				unless => "rpm -qa | grep squid-repo-1-1",
				path => '/bin:/sbin:/usr/bin:/usr/sbin',
			} 
		}
	}
}


