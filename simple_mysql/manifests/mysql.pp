# -*- mode: ruby -*-

package { 'libnss-mdns':
	ensure  => present,
}

group { 'puppet':
	ensure => present,
}

exec { 'update':
	command => '/usr/bin/apt-get update',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
}

package { 'mysql-server':
	ensure  => latest,
	require => Exec['update'], 
}

service { 'mysql':
	ensure  => running,
	require => Package['mysql-server'],
}

