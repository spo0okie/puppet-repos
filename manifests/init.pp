class repos {
	case $facts['os']['name'] {
		'CentOS': {
			case $facts['os']['release']['major'] {
				6,7: {
					package {'yum-plugin-priorities': ensure => 'installed'}
				}
			}
		}
	}
}
