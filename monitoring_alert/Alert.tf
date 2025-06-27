
resource "azurerm_monitor_action_group" "main" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "exampleact"

    email_receiver {
        name          = "example-email"
        email_address = "p.cozzy2012@gmail.com"
}
}
resource "azurerm_monitor_metric_alert" "example" {
  name                = "example-metricalert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  description         = "Action will be triggered when CPU is greater than 50."

  criteria {
    metric_namespace = "Microsoft.compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = "5"
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}