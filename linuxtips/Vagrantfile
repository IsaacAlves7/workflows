$curl = <<-SCRIPT 
sudo apt install curl -y && sudo apt clean
SCRIPT
$preconf = <<-SCRIPT
    sudo apt update && sudo apt install \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common -y 
SCRIPT
$repo = <<-SCRIPT
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
SCRIPT

Vagrant.configure("2") do |config|
config.vm.box = "ubuntu/focal64"
config.vm.define "et-01" do |et01|
    et01.vm.provision "shell", inline: "sudo apt update && sudo apt upgrade -y"
    et01.vm.provision "shell", inline: $curl
    et01.vm.provision "shell", inline: $preconf
    et01.vm.provision "shell", inline: "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
    et01.vm.provision "shell", inline: $repo
    et01.vm.provision "shell", inline: "sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y"
    et01.vm.provision "shell", inline: "sudo hostname et-01"
    et01.vm.network "public_network"
end
config.vm.define "et-02" do |et02|
    et02.vm.provision "shell", inline: "sudo apt update && sudo apt upgrade -y"
    et02.vm.provision "shell", inline: $curl
    et02.vm.provision "shell", inline: $preconf
    et02.vm.provision "shell", inline: "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
    et02.vm.provision "shell", inline: $repo
    et02.vm.provision "shell", inline: "sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y"
    et02.vm.provision "shell", inline: "sudo hostname et-02"
    et02.vm.network "public_network"
end
config.vm.define "et-03" do |et03|
    et03.vm.provision "shell", inline: "sudo apt update && sudo apt upgrade -y"
    et03.vm.provision "shell", inline: $curl
    et03.vm.provision "shell", inline: $preconf
    et03.vm.provision "shell", inline: "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
    et03.vm.provision "shell", inline: $repo
    et03.vm.provision "shell", inline: "sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y"
    et03.vm.provision "shell", inline: "sudo hostname et-03"
    et03.vm.network "public_network"
end
end
