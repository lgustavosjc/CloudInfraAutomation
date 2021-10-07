#! /bin/bash
sudo apt-get update
sudo apt install openjdk-11-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get -o Acquire::https::pkg.jenkins.io::Verify-Peer=false update
sudo apt-get -o Acquire::https::get.jenkins.io::Verify-Peer=false -o Acquire::https::pkg.jenkins.io::Verify-Peer=false install jenkins -y
sudo systemctl start jenkins