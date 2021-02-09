provider "azurerm" {
  tenant_id       = "ee61da1f-7fd4-4550-a7ff-b7767688d78b"
  subscription_id = "09d9f2d9-084c-455a-a64f-9c03e7820800"
  client_id = "ce19bac5-641f-422d-bbaf-c46417d94d07"
  client_secret = "l1u0LA5aM_lj7XAJc7In.~kiLWyRjSI5BG"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "tstate14798"
    container_name       = "tstate"
    access_key           = "V3sxaWgrqFwFz6RRb6YcooYDDScdgbgLnTAZpeToVe1Km+4YZ1/62lNXER+FQh0Sm6a7ffuqRDp++MVfEWWbNQ=="
  }

}
module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = "${var.resource_group}"
  location             = "${var.location}"
}
module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${module.resource_group.resource_group_name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${module.resource_group.resource_group_name}"
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${module.resource_group.resource_group_name}"
}
