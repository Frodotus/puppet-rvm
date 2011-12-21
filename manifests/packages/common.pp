class rvm::packages::common {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/rvm/bin',
  }
  
  exec { 'install-rvm':
    command => "bash -c '/usr/bin/curl -s https://rvm.beginrescueend.com/install/rvm -o /tmp/rvm-installer ; chmod +x /tmp/rvm-installer ; /tmp/rvm-installer --version latest'",
    creates => '/usr/local/rvm/bin/rvm',
    unless  => 'which rvm',
    require => Package['curl']
  }
}