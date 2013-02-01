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

file { '/etc/mysql/my.cnf':
	ensure 	=> present,
	source 	=> '/vagrant/manifests/my.cnf',
	require => Package['mysql-server'],
}

service { 'mysql':
	ensure    => running,
	require   => Package['mysql-server'],
	subscribe => File['/etc/mysql/my.cnf']
}

exec { 'create-schema':
	command => '/bin/echo "create schema evaluation; grant all on evaluation.* to root;" | /usr/bin/mysql -u root',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
	require => Service['mysql'],
}