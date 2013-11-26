class nagios_nrpe () {
#	$package_name="undefined"
	
	case $::operatingsystem {
		centos, redhat, oel : {
			$package_name="nagios-nrpe"
			$plugins_package_name="nagios-plugins"
			
			$rpmforge_rpm_name = "rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm"
			$rpmforge_rpm_url = "http://pkgs.repoforge.org/rpmforge-release/$rpmforge_rpm_name"
			$rpmforge_rpm_file = "/usr/local/src/$rpmforge_rpm_name"
	
			include wget 
			wget::fetch { "rpmforge_fetch" :
					source => "$rpmforge_rpm_url",
					destination => "$rpmforge_rpm_file",
			} -> exec { "rpmforge_install" :
					creates => "/etc/yum.repos.d/rpmforge.repo",
					command => "/bin/rpm -Uhv $rpmforge_rpm_file",
			}			
		}
		debian, ubuntu : {
			$package_name="nagios-nrpe-server"
			$plugins_package_name="nagios-plugins"
			
			exec { "rpmforge_install" : 
					command => "/bin/echo 'rpmforge repo is not required on ubuntu or debian'",
			}
		}
		opensuse, suse, sles : {
      $package_name="nagios-nrpe"
      $plugins_package_name="nagios-plugins"
      
      exec { "rpmforge_install" : 
          command => "/bin/echo 'rpmforge repo is not required on opensuse or suse'",
      }
    }
	}
	
	package { "$package_name" :
			ensure => present,
			require => Exec["rpmforge_install"]
	}
	
	package { "$plugins_package_name" :
			ensure => present,
			require => Package["$package_name"]
	}
}
