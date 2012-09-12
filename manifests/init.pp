# ==: Class portmap
#
# This module manages the portmap service
#
# ==: Parameters
#   [*ensure*]
#     Deprecated. In place to prevent errors if user sets the parameter
#
#   [*bind*]
#     IP address to bind to. Default binds to all IP
#     Optional
#
#   [*user*]
#     User to bind as. If set requires group to be set as well.
#     Optional
#
#   [*group*]
#     Group to bind as. If set requires user to be set as well.
#     Optional
#
#   [*chroot*]
#     Path to chroot the service into.
#     Optional
#
#   [*ensure_version*]
#     If puppet should pin service to specific version, or ensure latest version.
#     Valid options are version-number, latest or undef
#     Optional
#
# ==: Requires
#
# ==: Sample Usage
#
#   include portmap
#   include portmap::disable (to stop service)
#   include portmap::absent (to remove package / service)
#     or
#   class { "portmap": bind => "127.0.0.1", ensure_version => latest }
# 
class portmap ( $ensure = undef,
	            $bind = undef,
	            $user = undef,
	            $group = undef,
	            $chroot = undef,
	            $ensure_version = undef ) {
  
    include portmap::params
  
    if $ensure != undef {
        warning("Use of :ensure parameter is deprecated, include portmap::disable or portmap::absent if you want to decommission this module, or use :auto_update => true to keep portmap up to date")
    }

    package { $portmap::params::package_name:
        ensure => $ensure_version ? {
            undef => present,
            default => $ensure_version
        }
    }

    service { $portmap::params::service_name:
        ensure => running,
        enable => true,
        hasrestart => true,
        require => Package[$portmap::params::package_name]
    }

    case $::operatingsystem {
        default: {
            file { $portmap::params::daemon_settings:
                ensure => present,
                content => template("portmap/default.erb"),
                require => Package[$portmap::params::package_name],
                notify => Service[$portmap::params::service_name]
            }
        }
    }

}