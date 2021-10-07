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

  owners = [var.id_conta_aws]
}

data "aws_subnet" "subnet_public" {
   cidr_block = var.subnet_cidr
}


######### Criando recurso par de chaves ##########
resource "aws_key_pair" "jenkins-sshkey" {
    key_name = "jenkins-app-key"
    public_key = var.ssh_key

}

########## Criando a EC2 #########
resource "aws_instance" "jenkins-app" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.tipo_instancia
    subnet_id = data.aws_subnet.subnet_public.id
    associate_public_ip_address = true

    tags = {
        Name = "jenkins-app"
    }
    key_name = aws_key_pair.jenkins-sshkey.id
    # arquivo de bootstrap  
    user_data = file("${path.module}/files/jenkins.sh")
}



######## Security Group ############
resource "aws_security_group" "allow-jenkins" {
    name = "allow_jenkins"
    description = "Allow SSH and Port 8080"
    vpc_id = var.vpc_id

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

######### Atrelando EC2 e SG
resource "aws_network_interface_sg_attachment" "jenkins-sg" {
   security_group_id = aws_security_group.allow-jenkins.id
   network_interface_id = aws_instance.jenkins-app.primary_network_interface_id
}
