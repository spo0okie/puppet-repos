include repos
include repos::zabbix
package { 'zabbix-agent': ensure => installed }
