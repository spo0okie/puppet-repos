test_name 'apply repos module'

require_relative 'spec/spec_helper_acceptance'

provision_puppet()

install_dev_puppet_module_on(
  hosts,
  source: File.expand_path('.', __dir__),
  module_name: 'repos'
)

hosts.each do |host|
  apply_manifest_on(
    host,
    'include repos::zabbix',
    catch_failures: true
  )
end
