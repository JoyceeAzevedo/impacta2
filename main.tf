

 resource "azurerm_resource_group" "lab02" {
 name = "atividade-joyy"
 location = "southcentralus"
 tags ={

     evironment = "dev"
     source = "Terraform"
     owner = "joyceazevedo"
 }

}
 resource "azurerm_mssql_server" "lab02" {

name                               = "lab02-sqlserver"
resource_group_name               = azurerm_resource_group.lab02.name
location                          = azurerm_resource_group.lab02.location
version                           = "12.0"
administrator_login               = "impactaadm"
administrator_login_password      = "Adm@MBA01"

 }




resource "azurerm_mssql_database" "lab02" {
    name = "lab02-db"
    server_id = azurerm_mssql_server.lab02.id
}

resource "azurerm_mssql_database" "lab03" {
    name = "lab03-db"
    server_id = azurerm_mssql_server.lab02.id
}


resource "azurerm_storage_account" "lab02" {
    name                     = "salab01"
    resource_group_name      = azurerm_resource_group.lab02.name
    location                 = azurerm_resource_group.lab02.location
    account_tier             = "Standard"
    account_replication_type = "LRS" 
  
}

resource "azurerm_mssql_database_extended_auditing_policy" "lab02" {
    database_id                             = azurerm_mssql_database.lab02.id
    storage_endpoint                        = azurerm_storage_account.lab02.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.lab02.primary_access_key
    storage_account_access_key_is_secondary = false
    retention_in_days                       = 30
}

resource "azurerm_sql_firewall_rule" "lab02" {
    name                = "FirewallRule1"
    resource_group_name = azurerm_resource_group.lab02.name
    server_name         = azurerm_mssql_server.lab02.name
    start_ip_address    = ""
    end_ip_address      = ""
  
}
