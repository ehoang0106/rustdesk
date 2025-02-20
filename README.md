# Create a Remote Desktop Server using Ansible, Terraform, and RustDesk

This project automates the creation of a remote desktop server using Ansible, Terraform, and RustDesk. 

After the infrastructure is set up, the `ansible_server` installs Ansible, configures the inventory, and runs a playbook to install Docker and start Docker containers on the `rustdesk_server`.

## Setup

1. **Configure AWS Credentials**: Ensure your AWS credentials are configured using the AWS CLI or by exporting the environment variables.

2. **Initialize and Apply Terraform**: Navigate to the `terraform` directory, initialize Terraform, and apply the configuration to provision the infrastructure.

3. **Configure SSH Key Pair**: Copy the keypair to `~/.ssh/your-keypair.pem` in `ansible_server` then change the mode for keypair

```
chmod 400 ~/.ssh/your-keypair.pem
```

then start and switch ssh-agent to `bash` and add the keypair to ssh-agent

```
ssh-agent
ssh-agent bash
ssh-add ~/.ssh/your-keypair.pem
```


## Test connection between ansible and the host server

make sure cd into the `~/ansible`
```
ansible all -i inventory -m ping
```

ensure 2 files `playbook.yml` and `docker-compose.yml` in the `/ansible` folder are copied to path: `~/ansible`

then run ansible playbook

```
ansible-playbook -i inventory playbook.yml 
```