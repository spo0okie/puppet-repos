#во первых пришлось самостоятельно написать установку Puppet, 
#т.к. сам beaker что-то чудил и вот этот кусок кода написать было проще 
#чем заставить нативный provision работать как надо

#во вторых поскольку этот код не относится к самому тесту и может быть переиспользован
#он был вынесен в отдельный хелпер

require 'beaker-puppet'

def provision_puppet()
  #без прокси нам будет много чего недоступно
  proxy = ENV['HTTP_PROXY'] || ENV['http_proxy']
  raise 'HTTP_PROXY not set' unless proxy

  hosts.each do |host|
    create_remote_file(
      host,
      '/etc/apt/apt.conf.d/00test',
      <<~CONF
        Acquire::http::Proxy "#{proxy}";
        Acquire::https::Proxy "#{proxy}";
        Acquire::AllowInsecureRepositories "true";
        Acquire::AllowDowngradeToInsecureRepositories "true";
        APT::Get::AllowUnauthenticated "true";
      CONF
    )
    install_package(host, 'wget')
    create_remote_file(
      host,
      '/etc/wgetrc',
      <<~CONF
        use_proxy = on
        http_proxy = #{proxy}
        https_proxy = #{proxy}
      CONF
    )
    case host['platform']
    when /debian-9/
      on host, 'wget -O /tmp/puppet.deb https://apt.puppet.com/puppet6-release-stretch.deb'
      on host, 'dpkg -i /tmp/puppet.deb'
      on host, 'apt-get update'
      on host, 'apt-get install -y puppet-agent'

    when /debian-10/
      on host, 'wget -O /tmp/puppet.deb https://apt.puppet.com/puppet6-release-buster.deb'
      on host, 'dpkg -i /tmp/puppet.deb'
      on host, 'apt-get update'
      on host, 'apt-get install -y puppet-agent'

    when /debian-11/
      on host, 'wget -O /tmp/puppet.deb https://apt.puppet.com/puppet6-release-bullseye.deb'
      on host, 'dpkg -i /tmp/puppet.deb'
      on host, 'apt-get update'
      on host, 'apt-get install -y puppet-agent'

    when /centos-7/
      on host, 'rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm'
      on host, 'yum install -y puppet-agent'

    when /centos-6/
      on host, 'rpm -Uvh https://yum.puppet.com/puppet6-release-el-6.noarch.rpm'
      on host, 'yum install -y puppet-agent'

    when /centos-5/
      raise "CentOS 5 requires manual Puppet 6 archive repo"
    else
      raise "Unsupported platform #{host['platform']}"
    end
    #Хак чтобы не мучаться с PATH
    on host, 'ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet'
  end
end

