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

package { 'postgresql-9.1':
	ensure => latest,
	require => Exec['update'], 
}

service { 'postgresql':
	ensure  => running,
	require => Package['postgresql-9.1'],
}

