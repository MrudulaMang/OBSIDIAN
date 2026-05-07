# 🔧 Ansible Server Automation

> Automated provisioning and configuration management for multi-environment AWS infrastructure — from bare EC2 to fully configured application servers in minutes.

## 🏗️ What Gets Automated

- ✅ EC2 instance provisioning & hardening
- ✅ Docker & Docker Compose installation
- ✅ Nginx reverse proxy configuration
- ✅ Application deployment & restart
- ✅ Log rotation & cron setup
- ✅ Firewall rules (UFW)
- ✅ SSL certificate setup (Let's Encrypt)

## 📁 Repo Structure

```
ansible-server-automation/
├── inventory/
│   ├── dev.ini
│   └── prod.ini
├── roles/
│   ├── common/        # base hardening
│   ├── docker/        # docker install
│   ├── nginx/         # reverse proxy
│   └── app/           # app deploy
├── playbooks/
│   ├── site.yml       # full setup
│   ├── deploy.yml     # app only
│   └── patch.yml      # OS patching
├── group_vars/
│   ├── all.yml
│   ├── dev.yml
│   └── prod.yml
└── ansible.cfg
```

## 🔑 Key Snippet — App Deploy Playbook

```yaml
- name: Deploy application
  hosts: app_servers
  become: true
  vars_files:
    - group_vars/{{ env }}.yml

  tasks:
    - name: Pull latest Docker image
      community.docker.docker_image:
        name: "{{ ecr_repo }}/myapp:{{ image_tag }}"
        source: pull

    - name: Stop existing container
      community.docker.docker_container:
        name: myapp
        state: stopped
      ignore_errors: true

    - name: Start new container
      community.docker.docker_container:
        name: myapp
        image: "{{ ecr_repo }}/myapp:{{ image_tag }}"
        state: started
        restart_policy: always
        ports:
          - "8080:8080"
        env:
          ENV: "{{ env }}"
          DB_URL: "{{ db_url }}"

    - name: Health check
      uri:
        url: "http://localhost:8080/health"
        status_code: 200
      retries: 5
      delay: 10
```

## 🚀 How to Run

```bash
# Full server setup
ansible-playbook playbooks/site.yml -i inventory/dev.ini -e env=dev

# App deploy only
ansible-playbook playbooks/deploy.yml -i inventory/prod.ini \
  -e env=prod -e image_tag=1.4.2
```