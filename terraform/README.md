covid-19-grafana/terraform
===

# Sample `.tfvars` file
```toml
grafana_server_domain  = "example.com"
grafana_admin_user     = "admin"
grafana_admin_password = "thisisnotyourpassword"

aws_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0Ru52tplYR3TrDVkLprihVnRApZDYpSbSTjQGn7AWYgJm+... me@example.com"
```

# Select Terraform workspace
```sh
$ terraform workspace show
$ terraform workspace select production
```

# Apply
```sh
(terraform:production) $ terraform apply -var-file=production.tfvars 
```
