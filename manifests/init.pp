# == Class: stf & stf_iptables
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

class stf_iptables {

  firewall { '100 allow http and https':
    chain       => 'INPUT',
    state       => ['NEW'],
    dport       => [80, 443],
    proto       => tcp,
    action      => accept,
    destination => '192.168.10.12',
    source      => '192.168.10.10',
  }
  firewall { '101 allow ssh':
    chain       => 'INPUT',
    state       => ['NEW'],
    dport       => 22,
    proto       => tcp,
    action      => accept,
    destination => '10.0.2.15/32',
  }
  firewall { '102 allow ssh to public port':
    chain       => 'INPUT',
    state       => ['NEW'],
    dport       => 22,
    proto       => tcp,
    action      => accept,
    destination => '192.168.10.0/24',
  }
  firewall { '103 allow ntp':
    chain       => 'INPUT',
    dport       => 123,
    proto       => udp,
    action      => accept,
    destination => '10.100.100.10/32',
  }
  firewall { '104 allow tomcat':
    chain       => 'INPUT',
    dport       => 8080,
    proto       => tcp,
    action      => accept,
    source      => '! 10.100.100.11/32',
  }
}
