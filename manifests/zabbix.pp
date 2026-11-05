# Настраивает репозиторий Zabbix до установки пакета агента из другого класса.
class repos::zabbix {
  $matrix = {
    'Debian' => { '13' => '7.4', '12' => '7.2', '11' => '7.2', '10' => '7.0', '9'  => '6.0', },
    'Ubuntu' => { '24.04' => '7.2', '22.04' => '7.2', '20.04' => '7.2', '18.04' => '6.4', '16.04' => '6.0', },
    'RedHat' => { '8' => '7.2', '7' => '6.4', '6' => '6.0', },
    'CentOS' => { '8' => '7.2', '7' => '6.4', '6' => '6.0', },
    'SLES'   => { '15' => '7.2', },
  }

  $os        = $facts['os']['name']
  $release   = $facts['os']['release']['major']
  $ver = $matrix[$os][$release]
  $os_lc = downcase($os)

  if $ver == undef {
    fail("Zabbix: OS ${os} ${release} is not supported")
  }

  case $os {
    'Debian','Ubuntu': {
      $pkg = "zabbix-release_latest_${ver}+${os_lc}${release}_all.deb"

      file { "/tmp/${pkg}":
        source => "puppet:///modules/repos/zabbix/${pkg}",
      }
      -> exec { 'install_zabbix_repo':
        command  => "dpkg -i /tmp/${pkg} && apt-get update",
        # После apt remove версия остаётся в dpkg; сверяем статус и версию с нужным deb.
        unless   => "test \"$(dpkg-query -W -f='\${Status} \${Version}' zabbix-release)\" = \"install ok installed $(dpkg-deb -f /tmp/${pkg} Version)\" && apt-cache show zabbix-agent2 >/dev/null 2>&1",
        # Команда и проверка используют возможности shell: && и подстановку команд.
        provider => shell,
        path     => ['/bin','/usr/bin','/sbin','/usr/sbin'],
      }
    }

    'RedHat','CentOS','SLES': {
      $pkg = "zabbix-release-latest-${ver}.el${release}.noarch.rpm"

      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-B5333005':
        ensure => file,
        mode   => '0644',
        source => 'puppet:///modules/repos/zabbix/RPM-GPG-KEY-ZABBIX-B5333005',
      }

      exec { 'import-zabbix-gpg-b5333005':
        command => '/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-B5333005',
        unless  => '/bin/rpm -q gpg-pubkey-b5333005',
        require => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-B5333005'],
      }

      file { "/tmp/${pkg}":
        source => "puppet:///modules/repos/zabbix/${pkg}",
      }

      ~> exec { 'install_zabbix_repo':
        command => "rpm -Uvh --nosignature /tmp/${pkg}",
        unless  => "rpm -q zabbix-release | grep ${ver}",
        path    => ['/bin','/usr/bin','/sbin','/usr/sbin'],
      }
    }

    default: {
      raise('Unsupported OS')
    }
  }

  # Коллектор задаёт порядок, если агент объявлен в каталоге отдельным модулем.
  Exec['install_zabbix_repo'] -> Package <| title == 'zabbix-agent2' |>
}
