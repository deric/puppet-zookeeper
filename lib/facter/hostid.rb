# add hostid fact
# it grabs the last digits off the hostname to automatically provision services which need
# a host to have some sort of unique serial number
#
Facter.add(:hostid) do
  setcode do
    hostid = Facter.value(:hostname)
    hostid.gsub(/\D/, "")
  end
end
