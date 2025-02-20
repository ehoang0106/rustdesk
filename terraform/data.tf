data "local_file" "input_template" {
  filename = "${path.module}/apt-install.tftpl"
}

data "template_file" "user_data" {
  template = data.local_file.input_template.content
}