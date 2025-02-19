### ansible server

```
sudo apt-get update
sudo install apt ansible -y
cd ~
mkdir ansible && cd ansible
nano inventory
```

add these code to inventory

```
[servers]
rustdesk ansible_host=[YOUR RUSTDESK SERVER IP ADDRESS]
[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

download or create a keypair in `~/.ssh/your-keypair.pem`

then swith ssh-agent to bash and add the keypair to ssh-agent

```
ssh-agent bash
ssh-add ~/.ssh/your-keypair.pem
```

#### test connection between ansible and the host server

make sure cd into the `~/ansible`
```
ansible all -i inventory -m ping
```