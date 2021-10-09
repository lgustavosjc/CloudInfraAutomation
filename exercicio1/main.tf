module "slackapp" {
  source      = "./modules/slacko-app"
  vpc_id      = "vpc-0929582c1702ae4e3"
  subnet_cidr = "10.0.102.0/24"

    # Gerar SSH Key Publica -
    # cd ./modules/slacko-app/files/
    # ssh-keygen -C slacko-app -f slacko-app
    # cat ./modules/slacko-app/files/slacko-app.pub
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9z2nXTF0suLeCB3HGGYLZ/2/ekCqM+dKCcaE3aLftbjLw2frLeAJcj+vUFS88PSX2t9h5MbJD3BHFkAZiwXdBkZ1Rc8B9SUgEiPANhP84iAnfneFR/VX26BWZH8iyPgY/9DhwvP2SDH7wGBpZxMvxZPbbhWSMB5F9YFuRXMiUBCnS/2WS/ESgGm6ewPE9QOQPq6OGriK9s864X3bzJKbvnpIQ/SNhsn1k7yCuMctT4ByaHqSijEP7a/77KhscshaHaeKzN6J354fuzAqn3uHmyK7Rm/5Z1oQ3+MZ+tGUR0ycJvT0IntMvwqd02LQnk/2oXHLU6Cmjmz9EXQE+rgHGBvSv0XytIpeus7nhJ68teC6kevhqLbpmeXPU5EVlf9muBjwEs45rZ5s2605nKEA9KkLlVOGyG5xBb6NtywJnJ6bOsRsFode1IrPxrMR/ZzvfpoXBnvn8uqCkZuGJ2YafDtmQsZ0RgL+d08eko+TLylwRmUzGPlPpiNfOQ2W0LgE= slacko-app"

  # Sufixo - Slackoapp machine name
  app_name = "MyAPPp"


  tipo_instancia_slack   = "t2.micro"
  tipo_instancia_mongodb = "t2.small"


  # Tags ára os recuros
  app_tags ={
  ambiente = "TIPO DO AMBIENTE"  #PROD, HOMOL, DEV
  owner = "DONO DO PROJETO"  #PROJETO XPTO
  }

}

output "slackip" {
  value = module.slackapp.slacko-app
}



 