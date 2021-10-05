data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_subnet" "subnet_public" {
   cidr_block = "10.0.102.0/24"
}


# Gerando a chave
# ssh-keygen -C jenkins-app -f jenkins-app
resource "aws_key_pair" "jenkins-sshkey" {
    key_name = "jenkins-app-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVqMSm6jilZHy3PRH/6ZnNtQHAjPc31WUAvjnqbWKvsq4c82qUQ1CoDhmiTQ1tT8XbrQT4nboeUJEOO9/jy4sZObL6AbuXB/4d1YE5ZcXGzFu89plPlUVB0kE/LuH51ULPq/2UWj5W2oSgJfeGjLeHs/IA5CjLBooGyTAv+f68h3ULZwFTFV5KP1iLHqD1M93pFqLDNADmEeQPLyHLZFmBHFDfKuBVB9GQxUewRt30AJ0cnM1pHadBY1+qY0ID3ZqyHk9rLeztNDeTbDacIdIVKnHmHiufVYNsMZwxdAQ+gWCmc87iscHgyhqLDGJ1TBze40yJMl27Q/8pE9eqZsYIcxeZArNHRZ7j0xDc1vlvazT73Szoo7gU9iAVb5y+FvL7mywTFq8239R1C5fiZszXFI1ndWEf6lYOGe2KpeumTtE2utr5mcejm5uYkGomNQ4e0vLCsTGseshi8QruupDoW3ZSfIAsfI7mS+m5MT9ylSJjvvm0FAN0FbQzLPzgSn0= jenkins-app"

}


resource "aws_instance" "jenkins-app" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3a.small"
    subnet_id = data.aws_subnet.subnet_public.id
    associate_public_ip_address = true

 connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/lg.pem")
  
  
 provisioner "remote-exec" {
    inline = [ 
        "cat /var/lib/jenkins/secrets/initialAdminPassword",
        "echo TESTE > /var/tmp/teste.txt",            ]

} 
  
  
  }

    tags = {
        Name = "jenkins-app"
    }

    #key_name = aws_key_pair.jenkins-sshkey.id
    key_name = "lg"

    # arquivo de bootstrap  
    user_data = file("jenkins.sh")  

 
}




resource "aws_security_group" "allow-jenkins" {
    name = "allow_ssh_http"
    description = "Allow ssh and http port"
    vpc_id = "vpc-0929582c1702ae4e3"

    ingress =[
    {
        description = "Allow SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = [] 
        security_groups = []
    },
    {
        description = "Allow Jenkins"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = [] 
        security_groups = []
    }
]

    egress = [
    {
        description = "Allow all"
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = [] 
        security_groups = []
    }
]

 tags = {
  Name = "allow_ssh_jenkins"
 }
}


resource "aws_network_interface_sg_attachment" "jenkins-sg" {
   security_group_id = aws_security_group.allow-jenkins.id
   network_interface_id = aws_instance.jenkins-app.primary_network_interface_id
}