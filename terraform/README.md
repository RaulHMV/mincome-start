# Mincome database Terraform

This directory defines the private PostgreSQL RDS service, the `mincome` database,
and exactly three tables from the README's relational model:

- `planes`
- `usuarios`
- `categorias`

The PostgreSQL provider needs the RDS endpoint before it can create the logical
database and tables. Apply the RDS service first, then apply the database schema
with the endpoint returned by Terraform:

```powershell
terraform init
terraform apply -target=aws_db_instance.database
$endpoint = terraform output -raw database_endpoint
terraform apply -var="database_host=$endpoint"
```

Pass the required VPC, subnet, credentials, and allowed CIDR variables through a
non-committed `.tfvars` file or environment variables. Do not store credentials
in the repository.
