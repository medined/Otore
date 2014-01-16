
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

host { 'otore.example.com': ip => '10.211.55.100' }
host { 'affy-slave1.example.com': ip => '10.211.55.101' }
host { 'affy-slave2.example.com': ip => '10.211.55.102' }

sysctl::value { "vm.swappiness": value => "10"}

exec { "apt-get update":
    command => "/usr/bin/apt-get -y update",
}

package { 'curl' :
    ensure  => 'installed',
    require => Exec['apt-get update'],
}

package { 'firefox' :
    ensure  => 'installed',
    require => Exec['apt-get update'],
}

package { 'git' :
    ensure  => 'installed',
    require => Exec['apt-get update'],
}

package { 'ia32-libs-gtk' :
    ensure  => 'installed',
    require => Exec['apt-get update'],
}

package { 'openjdk-7-jre-headless' :
    ensure  => 'installed',
    require => Exec['apt-get update'],
}

package { 'unzip' :
    ensure  => 'installed',
    require => Exec['apt-get update'],
}

group { "supergroup":
    ensure => "present",
} ->
user { "root":
    ensure => present,
    gid => "supergroup",
} ->
user { "vagrant":
    ensure => present,
    gid => "supergroup",
}

group { "puppet":
	ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }
 
file { '/etc/motd':
	content => "Welcome to your Vagrant-built Puppet-managed virtual machine.\n",
}

exec { "install_android_apt" :
    command => "unzip -d /usr/local /vagrant/files/adt-bundle-linux-x86_64-20131030.zip",
    require => Package['ia32-libs-gtk'],
    require => Package['unzip'],
} -> 
file { "/usr/local/adt-bundle-linux-x86_64-20131030":
    owner => "vagrant",
    group => "supergroup",
}
