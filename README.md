
# Create a Remote Desktop Server using Ansible, Terraform and RustDesk



### SSH to ansible server
Run: 
```
sudo apt-get update
sudo install apt ansible -y
cd ~
mkdir ansible && cd ansible
nano inventory
```

add these code to inventory

note: replace ip `10.0.1.69` by your host ip address. in this case, i use my static ip
```
[servers]
rustdesk ansible_host=10.0.1.69
[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

download or create a keypair in `~/.ssh/your-keypair.pem`

change the mode for keypair

```
chmod 400 ~/.ssh/your-keypair.pem
```

then swith ssh-agent to `bash` and add the keypair to ssh-agent

```
ssh-agent bash
ssh-add ~/.ssh/your-keypair.pem
```

#### test connection between ansible and the host server

make sure cd into the `~/ansible`
```
ansible all -i inventory -m ping
```

ensure 2 files `playbook.yml` and `docker-compose.yml` in the `/ansible` folder are copied to path: `~/ansible`

then run ansible play book

```
ansible-playbook -i inventory playbook.yml 
```

