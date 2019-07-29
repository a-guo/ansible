# vi: set ft=ruby :

# Builds VMs using a JSON template file and bash & ansible post provisioning
# read vm and chef configurations from JSON files
nodes_config = (JSON.parse(File.read("nodes.json")))['nodes']

# private_key_path = File.join(Dir.home, ".ssh", "puppet_id_rsa")
# public_key_path = File.join(Dir.home, ".ssh", "puppet_id_rsa.pub")
# insecure_key_path = File.join(Dir.home, ".vagrant.d", "insecure_private_key")
#
# private_key = IO.read(private_key_path)
# public_key = IO.read(public_key_path)

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # config.ssh.insert_key = false
    # config.ssh.private_key_path = [ private_key_path, insecure_key_path ]
    #
    # config.vm.provision :shell, :inline => <<-SCRIPT
    # set -e
    #
    # #hascking the ssh keys to pull files from GIT using ssh protocol.
    # echo '#{private_key}' > /home/vagrant/.ssh/id_rsa
    # chmod 600 /home/vagrant/.ssh/id_rsa
    # chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
    # echo '#{public_key}' > /home/vagrant/.ssh/authorized_keys
    # chmod 600 /home/vagrant/.ssh/authorized_keys
    # chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
    # echo '#{public_key}' > /home/vagrant/.ssh/id_rsa.pub
    # chmod 600 /home/vagrant/.ssh/id_rsa.pub
    # chown vagrant:vagrant /home/vagrant/.ssh/id_rsa.pub
    #
    # #hascking the ssh keys to pull files from GIT using ssh protocol.
    # sudo bash -c "mkdir -p /root/.ssh"
    # sudo bash -c "echo '#{private_key}' > /root/.ssh/id_rsa"
    # sudo bash -c "chmod 600 /root/.ssh/id_rsa"
    # sudo bash -c "echo '#{public_key}' > /root/.ssh/authorized_keys"
    # sudo bash -c "chmod 600 /root/.ssh/authorized_keys"
    # sudo bash -c "echo '#{public_key}' > /root/.ssh/id_rsa.pub"
    # sudo bash -c "chmod 600 /root/.ssh/id_rsa.pub"
    # sleep 10
    # echo "GOING TO INSTALL MASTER OF PUPPETS"
    # SCRIPT
    #

  nodes_config.each do |node|
    node_name   = node[0] # name of node
    node_values = node[1] # content of node

    config.vm.define node_name do |config|
      # configures all forwarding ports in JSON array
      ports = node_values['ports']
      ports.each do |port|
        config.vm.network :forwarded_port,
          host:  port[':host'],
          guest: port[':guest'],
          id:    port[':id']
      end

      config.vm.box = nodes_config[node_name][':os_image']
      config.vm.hostname = node_name
      config.vm.network :forwarded_port, guest: node_values[':guest'], host: node_values[':host']

      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", node_values[':memory']]
        vb.customize ["modifyvm", :id, "--name", node_name]
      end

      provisioner = node_values[':provisioner']
      config.vm.provision "fix-no-tty", type: "shell" do |s|
          s.privileged = false
          s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
      end
      if provisioner == 'bash_script'
        config.vm.provision :shell, :path => node_values[':bootstrap']
      else
        config.vm.provision :ansible, :playbook => node_values[':ansible_playbook']
      end
    end
  end
end
