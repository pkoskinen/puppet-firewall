# == Class: stf
#
# Base class of this module.
#
class stf {
  $http_sources = '192.168.10.11, 10.10.10.10'
  $ssh_sources = '0.0.0.0/0'

  firewalld::service { 'sshd':
    ports => [
    {
      port     => 22,
      protocol => 'tcp' },
    ]
  }
  firewalld::service { 'httpd':
    ports => [
    {
      port     => 80,
      protocol => 'tcp'},
    {
      port     => 443,
      protocol => 'tcp'},
    ]
  }
  firewalld::zone { 'serviceExternal':
    sources    => [ $http_sources, $ssh_sources],
    services   => [ 'httpd', 'sshd' ],
    interfaces => 'eth1',
  }
}
