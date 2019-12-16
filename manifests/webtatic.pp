class repos::webtatic {
	include repos
	exec { 'install_webtatic_repo':
		command => "rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm",
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
		unless => 'ls -1 /etc/yum.repos.d | grep webtatic'
	}
}