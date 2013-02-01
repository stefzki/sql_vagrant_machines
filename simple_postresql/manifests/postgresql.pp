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

file { '/etc/postgresql/9.1/main/postgresql.conf':
	ensure => present,
	source => '/vagrant/manifests/postgresql.conf',
	require => Package['postgresql-9.1'],
}
	
service { 'postgresql':
	ensure  => running,
	require => Package['postgresql-9.1'],
	subscribe => File['/etc/postgresql/9.1/main/postgresql.conf']
}

exec { 'create-user':
	command => '/usr/bin/createuser -s -d root',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
	require => Service['postgresql'],
}

exec { 'create-database':
	command => '/usr/bin/createdb -O root evaluation',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
	require => [ Service['postgresql'], Exec['create-user'] ],
}

