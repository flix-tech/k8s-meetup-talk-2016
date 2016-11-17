Vagrant.configure(2) do |config|
  config.vm.box = "flixtech/kubernetes"
  # Disabled VirtualBox Guest updates
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 1536
    v.cpus = 2
  end

  config.vm.box_version = ">= 1.4.6"

  config.vm.provision "shell",
      inline: "/nfs-data/apps/init.sh"

  config.ssh.forward_agent = true

  # Use NFS for better performance
  config.vm.synced_folder "apps", "/nfs-data/apps",
      :nfs => true,
      :mount_options => ['rw','async','noatime','rsize=32768','wsize=32768','proto=tcp']

end
