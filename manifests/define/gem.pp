define rvm::define::gem(
  $ensure = 'present',
  $ruby_version,
  $gemset = '',
  $gem_version = ''
) {  
  ## Set sensible defaults for Exec resource
  Exec {
    path    => '/usr/local/rvm/bin:/bin:/sbin:/usr/bin:/usr/sbin',
  }
  
  # Local Parameters
  $rvm_path = '/usr/local/rvm'
  $rvm_ruby = "${rvm_path}/rubies"
  
  if $gemset == '' {
    $rvm_depency = "install-ruby-${ruby_version}"        
  } else {
    $rvm_depency = "rvm-gemset-create-${gemset}-${ruby_version}"        
    $rubyset_version = "${ruby_version}@${gemset}"
  }
  # Setup proper install/uninstall commands based on gem version.
  if $gem_version == '' {
    $gem = {
      'install'   => "rvm ${rubyset_version} gem install ${name} --no-ri --no-rdoc",
      'uninstall' => "rvm ${rubyset_version} gem uninstall ${name}",
      'lookup'    => "rvm gem list | grep ${name}",
    }
  } else {
    $gem = {
      'install'   => "rvm ${rubyset_version} gem install ${name} -v ${gem_version} --no-ri --no-rdoc",
      'uninstall' => "rvm ${rubyset_version} gem uninstall ${name} -v ${gem_version}",
      'lookup'    => "rvm gem list | grep ${name} | grep ${gem_version}",
    }
  }

  
  ## Begin Logic
  if $ensure == 'present' {
    exec { "rvm-gem-install-${name}-${ruby_version}":
      command => $gem['install'],
      unless  => $gem['lookup'],
      require => [Class['rvm'], Exec[$rvm_depency]],
    }
  } elsif $ensure == 'absent' {
    exec { "rvm-gem-uninstall-${name}-${version}":
      command => $gem['uninstall'],
      onlyif  => $gem['lookup'],
      require => [Class['rvm'], Exec[$rvm_depency]],
    }    
  }
}