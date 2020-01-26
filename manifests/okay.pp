#хер знает что за мексиканская  епа ваще, но в ней дофига всего что нужно для астера и чего нет в центос8
class repos::okay {
	include repos
	package { 'okay-release':
		source => 'http://repo.okay.com.mx/centos/8/x86_64/release/okay-release-1-3.el8.noarch.rpm',
		#provider
		ensure => installed,
	}
}
