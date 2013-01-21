# == Class: vmwaretools::install::package
#
# This class handles VMware Tools package-related installation duties
#
# == Actions:
#
# Ensures open-vm-tools is absent - this module directly conflicts.
# Installs Perl if it hasn't been installed by another module
# If we're running on a Debian system, install kernel headers and build tools
# On a RedHat system and we really want to install kernel headers, do it.
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) 2012 Craig Watson
#
class vmwaretools::install::package {

  case $::osfamily {

    'Debian' : {
      package { ["linux-headers-${::kernelrelease}",'build-essential'] :
        ensure => present,
      }
      package { 'open-vm-tools':
        ensure => purged,
      }
      if (!defined(Package[$perl])) {
        package { $perl:
          ensure => present,
        }
      }
    }

    'RedHat' : {
      if $vmwaretools::redhat_install_devel == true {
        package { 'kernel-devel':
          ensure => present,
        }
      }
      package { 'open-vm-tools':
        ensure => purged,
      }
      if (!defined(Package[$perl])) {
        package { $perl:
          ensure => present,
        }
      }
    }
    'Solaris' : {
      if (!defined(Package['SUNWperl584core'])) {
        package { 'SUNWperl584core':
          ensure => present,
        }
      }
      if (!defined(Package['SUNWperl584usr'])) {
        package { 'SUNWperl584usr':
          ensure => present,
        }
      }
    }

    default : { fail "${::osfamily} not supported yet." }
  }

}
