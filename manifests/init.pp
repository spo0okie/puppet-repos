class repos {
	case $::operatingsystem {
		'CentOS': {
			package {'yum-plugin-priorities': ensure => 'installed'}
		}
	}
}
