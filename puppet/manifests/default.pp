
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

host { 'otore.example.com': ip => '10.211.55.100' }
host { 'affy-slave1.example.com': ip => '10.211.55.101' }
host { 'affy-slave2.example.com': ip => '10.211.55.102' }

sysctl::value { "vm.swappiness": value => "10"}

exec { "apt-get update":
    command => "/usr/bin/apt-get -y update"
}

group { "supergroup":
    ensure => "present"
}

user { "root":
    ensure => present,
    gid => "supergroup"
}

user { "vagrant":
    ensure => present,
    gid => "supergroup"
}

package { [ 'curl', 'git', 'maven', 'x11-apps' ] :
    ensure  => 'installed',
    require => Exec['apt-get update']
}
