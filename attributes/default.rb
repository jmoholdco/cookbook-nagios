default['nagios']['build_dependencies'] =
  %w(gcc glibc glibc-common gd-devel make net-snmp openssl-devel xinetd unzip)

default['nagios']['version'] = '4.1.1'
default['nagios']['checksum'] =
  '986c93476b0fee2b2feb7a29ccf857cc691bed7ca4e004a5361ba11f467b0401'

default['nagios']['plugins']['version'] = '2.1.1'
default['nagios']['plugins']['checksum'] =
  'c7daf95ecbf6909724258e55a319057b78dcca23b2a6cc0a640b90c90d4feae3'

default['nagios']['admin_user'] = {
  'username' => 'nagios',
  'primary_group' => 'nagios',
  'secondary_groups' => %w(nagcmd),
  'email_address' => 'j.morgan.lieberthal@gmail.com'
}

default['nagios']['nrpe']['version'] = '2.15'
default['nagios']['nrpe']['checksum'] =
  '66383b7d367de25ba031d37762d83e2b55de010c573009c6f58270b137131072'
