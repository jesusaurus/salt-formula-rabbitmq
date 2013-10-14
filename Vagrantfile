Vagrant.configure("2") do |config|
  ## Choose your base box
  config.vm.box = "precise-server-cloudimg-20131014"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/20131014/precise-server-cloudimg-amd64-vagrant-disk1.box"

  ## For masterless, mount your salt file root
  config.vm.synced_folder ".", "/srv/salt/"
  config.vm.synced_folder "vagrant/pillar", "/srv/pillar/"

  ## Use all the defaults:
  config.vm.provision :salt do |salt|
    salt.verbose = true

    salt.minion_config = "vagrant/minion"
    salt.run_highstate = true
  end
end
