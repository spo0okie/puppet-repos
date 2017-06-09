#репозиторий в котором хранится sngrep
class repos::irontec {
	include repos
	file {'/etc/yum.repos.d/irontec.repo':
		require => Package['yum-plugin-priorities'],
		source => 'puppet:///modules/repos/irontec.repo',
		owner => 'root',
		mode => '0644'
	} ~>
	exec { 'install_irontec_key':
		command => "rpm --import http://packages.irontec.com/public.key",
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
		refreshonly => true,
	}
}


