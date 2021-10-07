module "jenkinsapp" {
    source = "./modules/jenkins-app"
    
    # Preencher com o VPC ID
    vpc_id = "vpc-XXXXXXXXXXXXX"
    
    #Preencher com a subnet
    subnet_cidr = "10.X.X.X/24"
    
    #Preencher com ID da Conta AWS
    id_conta_aws = "XXXXXXXXXX"

    #Preencher com tipo de instancia Ex: t3a.small
    tipo_instancia = "t3a.XXXXX"

    # SSH Key Publica - 
    # cd ./modules/jenkins-app/files/
    # ssh-keygen -C jenkins-app -f jenkins-app
    # cat ./modules/jenkins-app/files/jenkins-app.pub
    ssh_key = "ssh-rsa XXXXXXXXXXXXXXXX jenkins-app"

}


resource "null_resource" "getJenkinsPwd" {
    triggers = {
        instance = module.jenkinsapp.jenkins-app
    }
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("${path.module}/modules/jenkins-app/files/jenkins-app")
        host = module.jenkinsapp.jenkins-app
    }
    provisioner "remote-exec" {
    inline = [
        "sleep 180",
        "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
    ]
  }
}

output "jenkins-ip" {
    value = module.jenkinsapp.jenkins-app
}