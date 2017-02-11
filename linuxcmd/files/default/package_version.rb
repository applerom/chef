Ohai.plugin(:PackageVersion) do
  provides "package_version"

  depends "platform_family"

  collect_data do
    pckg_list = Hash.new
    case platform_family
      when 'debian'
        pckg_list = eval '{'+`dpkg-query -W -f='"${Package}"=> "${Version}", '`+'}'
      when 'rhel' || 'fedora'
        pckg_list = eval '{'+`rpm -qa --queryformat '"%{NAME}"=> "%{VERSION}", '`+'}'
      when 'arch'
        pckg_list = eval '{'+`package-query -Q -f '"%n"=> "%v", '`+'}'
      when 'gentoo'
        pckg_list = eval '{'+`equery list --format='"$name" => "$version", ' '*'`+'}'
      end                                                                                                    
    package_version Mash.new pckg_list
  end                                                                                                                   
end