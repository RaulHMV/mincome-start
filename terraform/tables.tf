resource "postgresql_table" "planes" {
  name              = "planes"
  database          = postgresql_database.mincome.name
  schema            = "public"
  owner             = var.database_admin_username
  tablespace        = "pg_default"
  on_commit         = "PRESERVE ROWS"
  depends_on        = [postgresql_extension.pgcrypto]

  column {
    name       = "id"
    type       = "smallserial"
    not_null   = true
  }

  column {
    name     = "nombre"
    type     = "varchar(30)"
    not_null = true
  }

  column {
    name     = "limite_consultas_mes"
    type     = "integer"
    not_null = true
  }

  column {
    name     = "limite_tokens_mes"
    type     = "integer"
    not_null = true
  }

  column {
    name     = "precio_mensual"
    type     = "numeric(8,2)"
    not_null = true
    default  = "0"
  }

  column {
    name     = "incluye_asistente"
    type     = "boolean"
    not_null = true
    default  = "false"
  }

  column {
    name     = "activo"
    type     = "boolean"
    not_null = true
    default  = "true"
  }

  primary_key {
    name    = "planes_pkey"
    columns = ["id"]
  }

  unique_constraint {
    name    = "planes_nombre_key"
    columns = ["nombre"]
  }

  check_constraint {
    name            = "planes_limite_consultas_mes_check"
    check_expression = "limite_consultas_mes >= 0"
  }

  check_constraint {
    name            = "planes_limite_tokens_mes_check"
    check_expression = "limite_tokens_mes >= 0"
  }

  check_constraint {
    name            = "planes_precio_mensual_check"
    check_expression = "precio_mensual >= 0"
  }
}

resource "postgresql_table" "usuarios" {
  name       = "usuarios"
  database   = postgresql_database.mincome.name
  schema     = "public"
  owner      = var.database_admin_username
  depends_on = [postgresql_extension.pgcrypto, postgresql_table.planes]

  column {
    name       = "id"
    type       = "uuid"
    not_null   = true
    default    = "gen_random_uuid()"
  }

  column {
    name     = "plan_id"
    type     = "smallint"
    not_null = true
  }

  column {
    name     = "nombre"
    type     = "varchar(100)"
    not_null = true
  }

  column {
    name     = "correo"
    type     = "varchar(254)"
    not_null = true
  }

  column {
    name     = "cognito_sub"
    type     = "varchar(64)"
    not_null = true
  }

  column {
    name     = "saldo_inicial"
    type     = "numeric(14,2)"
    not_null = true
    default  = "0"
  }

  column {
    name     = "moneda"
    type     = "char(3)"
    not_null = true
    default  = "'MXN'"
  }

  column {
    name     = "activo"
    type     = "boolean"
    not_null = true
    default  = "true"
  }

  column {
    name = "ultimo_acceso"
    type = "timestamptz"
  }

  column {
    name     = "creado_en"
    type     = "timestamptz"
    not_null = true
    default  = "now()"
  }

  column {
    name     = "actualizado_en"
    type     = "timestamptz"
    not_null = true
    default  = "now()"
  }

  foreign_key {
    name      = "usuarios_plan_id_fkey"
    columns   = ["plan_id"]
    on_delete = "RESTRICT"
    references {
      table = "planes"
      columns = ["id"]
    }
  }

  primary_key {
    name    = "usuarios_pkey"
    columns = ["id"]
  }

  unique_constraint {
    name    = "usuarios_correo_key"
    columns = ["correo"]
  }

  unique_constraint {
    name    = "usuarios_cognito_sub_key"
    columns = ["cognito_sub"]
  }

  check_constraint {
    name            = "usuarios_saldo_inicial_check"
    check_expression = "saldo_inicial >= 0"
  }
}

resource "postgresql_table" "categorias" {
  name       = "categorias"
  database   = postgresql_database.mincome.name
  schema     = "public"
  owner      = var.database_admin_username
  depends_on = [postgresql_table.usuarios]

  column {
    name       = "id"
    type       = "serial"
    not_null   = true
  }

  column {
    name = "usuario_id"
    type = "uuid"
  }

  column {
    name     = "nombre"
    type     = "varchar(50)"
    not_null = true
  }

  column {
    name = "icono"
    type = "varchar(40)"
  }

  column {
    name     = "tipo_aplicable"
    type     = "varchar(10)"
    not_null = true
  }

  column {
    name     = "es_sistema"
    type     = "boolean"
    not_null = true
    default  = "false"
  }

  foreign_key {
    name      = "categorias_usuario_id_fkey"
    columns   = ["usuario_id"]
    on_delete = "CASCADE"
    references {
      table   = "usuarios"
      columns = ["id"]
    }
  }

  primary_key {
    name    = "categorias_pkey"
    columns = ["id"]
  }

  unique_constraint {
    name    = "categorias_usuario_nombre_key"
    columns = ["usuario_id", "nombre"]
  }

  check_constraint {
    name            = "categorias_tipo_aplicable_check"
    check_expression = "tipo_aplicable IN ('ingreso', 'gasto', 'ambos')"
  }
}
