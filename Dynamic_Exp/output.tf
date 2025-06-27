output "demo" {
  value = [ for count in local.nsg_rules : count]
  }

output "splat" {
    value = local.nsg_rules[*] #To use this with indexing e.g ( [0], [1]), it oly works with list.
  }