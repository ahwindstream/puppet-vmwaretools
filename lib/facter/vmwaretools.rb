Facter.add("vmwaretools") do
  confine :virtual => :vmware
  setcode do
    if File::executable?("/usr/bin/vmware-toolbox-cmd")
      Facter::Util::Resolution.exec("/usr/bin/vmware-toolbox-cmd -v").sub(%r{(\d*\.\d*\.\d*)\.\d*\s+\(build(-\d*)\)},'\1\2')
    end
  end
end
