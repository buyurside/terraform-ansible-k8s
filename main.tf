resource "null_resource" "ansible" {
  depends_on = [local_file.ansible-inventory]
  provisioner "local-exec" {
    command = "cd ./ansible/; ./install-k8s.sh"
  }

  triggers = {
    always_run = timestamp()
  }
}
