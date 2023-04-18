resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.testserver.id
  allocation_id = "eipalloc-0ec3da46994ebecaf"
}
resource "aws_instance" "testserver" {
  ami           = "ami-06fc49795bc410a0c" 
  instance_type = "t2.micro" 
  key_name = "awsajay2999"
  vpc_security_group_ids= ["sg-04463616331ddcb75"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./awsajay2999.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "testserver"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.testserver.public_ip} > inventory "
 }
 
 provisioner "local-exec" {
 command = "sudo ansible-playbook /var/lib/jenkins/workspace/project2-banking/test_server/ajay_playbook.yml "
  } 
}

output "testserver_public_ip" {

  value = aws_eip_association.eip_assoc.public_ip
  
}
