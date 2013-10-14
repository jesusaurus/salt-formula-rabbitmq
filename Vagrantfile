Vagrant.configure("2") do |config|
  ## Choose your base box
  config.vm.box = "precise-server-cloudimg-20131014"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/20131014/precise-server-cloudimg-amd64-vagrant-disk1.box"

  ## Set the Hostname
  config.vm.hostname = "vagrant-rabbitmq"

  ## Share the necessary salt stuffs
  config.vm.synced_folder ".", "/srv/salt/"
  config.vm.synced_folder "vagrant/pillar", "/srv/pillar/"

  # Setup some port forwards:
  config.vm.network "forwarded_port", guest: 5671, host: 5671    # AMQP SSL
  config.vm.network "forwarded_port", guest: 5672, host: 5672    # AMQP
  config.vm.network "forwarded_port", guest: 15671, host: 15671  # Management UI SSL
  config.vm.network "forwarded_port", guest: 15672, host: 15672  # Management UI


  ## Provision the VM using Salt
  config.vm.provision :salt do |salt|
    salt.verbose = true

    salt.minion_config = "vagrant/minion"
    salt.run_highstate = true
  end
end
