class portmap::disable {	
	include portmap::params
	Service[$portmap::params::service_name] {
		ensure => stopped,
		enable => false
	}
}