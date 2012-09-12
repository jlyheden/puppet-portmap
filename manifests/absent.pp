class portmap::absent {
  include portmap::params
  Package[$portmap::params::package_name] {
    ensure => purge
  }
  case $::operatingsystem {
  	default: {
      File [$portmap::params::daemon_settings] {
      	ensure => undef
      }
  	}
  }

}