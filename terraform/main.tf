resource "aws_security_group" "database" {
  name        = "mincome-database"
  description = "Private PostgreSQL access for Mincome."
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from approved application networks"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.database_allowed_cidr_blocks
  }

  egress {
    description = "Allow database response traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "mincome-database"
    Service = "mincome"
  }
}

resource "aws_db_subnet_group" "database" {
  name       = "mincome-database"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = "mincome-database"
    Service = "mincome"
  }
}

resource "aws_db_instance" "database" {
  identifier              = "mincome-postgresql"
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = var.database_instance_class
  allocated_storage       = var.database_storage_gb
  max_allocated_storage   = var.database_storage_gb * 2
  storage_type            = "gp3"
  db_name                 = null
  username                = var.database_admin_username
  password                = var.database_admin_password
  port                    = var.database_port
  db_subnet_group_name    = aws_db_subnet_group.database.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  publicly_accessible     = false
  storage_encrypted       = true
  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name    = "mincome-postgresql"
    Service = "mincome"
  }
}

resource "postgresql_database" "mincome" {
  name              = var.database_name
  owner             = var.database_admin_username
  template          = "template0"
  encoding          = "UTF8"
  lc_collate        = "C"
  lc_ctype          = "C"
  connection_limit  = -1
  allow_connections = true

  depends_on = [aws_db_instance.database]
}

resource "postgresql_extension" "pgcrypto" {
  name     = "pgcrypto"
  database = postgresql_database.mincome.name
}
