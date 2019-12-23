class repos::squid-mirror {
	case $::operatingsystem {
		'CentOS': {
			yumrepo {'squid-mirror':
				'name'=>"Squid repo for CentOS Linux - ${::operatingsystemmajrelease}",
				'baseurl'=>"http://repo-mirrors.yamalgazprom.local/squid/centos/$releasever/beta/$basearch/",
				'failovermethod'='priority',
				'enabled'=>true,
				'gpgcheck'=>false
			} 
		}
	}
}


