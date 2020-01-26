class repos {
	case $::operatingsystem {
		'CentOS': {
			case $::operatingsystemmajrelease {
				6,7: {
					package {'yum-plugin-priorities': ensure => 'installed'}
				}
			}
		}
	}
}
