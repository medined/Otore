
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

$adt_version = "adt-bundle-linux-x86_64-20131030"
$adt_url = "http://dl.google.com/android/adt/${adt_version}.zip"
$adt_cache_file = "/vagrant/files/${adt_version}.zip"
$adt_install_base_dir = "/usr/local"
$adt_install_dir = "${adt_install_base_dir}/${adt_version}"

exec { "get_android_apt" :
	command => "wget --quiet --output-document=${adt_cache_file} ${adt_url}",
	timeout => 1800,
	creates => $adt_cache_file,
} ->
exec { "install_android_apt" :
    command => "unzip -d ${adt_install_base_dir} ${$adt_cache_file}",
    require => [ Package['ia32-libs-gtk'], Package['unzip'] ],
} ->
exec { "change_android_apt_ownership" :
	command => "chown -R vagrant:supergroup $adt_install_dir",
}

file { 'setup_eclipse_on_path' :
    path    => '/etc/profile.d/eclipse_setup.sh',
    ensure  => present,
    mode    => 0644,
    content => "export PATH=${adt_install_dir}/eclipse:\$PATH",
}
