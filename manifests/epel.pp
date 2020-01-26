#можно ставить и из centos-репы, но потом надо проверять что он последний, он поже сначала ставится из центоса, а потом уже в епел есть актуальный
class repos::epel {
	include repos
	package { 'epel-release':
		#source => 'http://repo.okay.com.mx/centos/8/x86_64/release/okay-release-1-3.el8.noarch.rpm',
		#provider
		ensure => latest,
	}
}
