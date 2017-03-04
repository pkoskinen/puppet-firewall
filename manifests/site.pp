node 'service.local' {
  include stf
}
node 'service2.local' {
  resources { 'firewall':
    purge => true,
  }
  Firewall {
    before  => Class['stf_iptables::post'],
    require => Class['stf_iptables::pre'],
  }
  class { ['stf_iptables::pre', 'stf_iptables::post']: }

  include stf_iptables
}
