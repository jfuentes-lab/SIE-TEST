
data "akamai_property_rules_template" "rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
}

resource "akamai_edge_hostname" "jfuentes-akamai-cm-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "jfuentes.akamai.cm.edgesuite.net"
  ttl           = 21600
}

resource "akamai_edge_hostname" "jfuentes-akamai-com-edgekey-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV4"
  edge_hostname = "jfuentes.akamai.com.edgekey.net"
}

resource "akamai_property" "jfuentes-newhirelab-com" {
  name        = "jfuentes.newhirelab.com"
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_Site_Accel"
  hostnames {
    cname_from             = "failover.jfuentes.com"
    cname_to               = akamai_edge_hostname.jfuentes-akamai-cm-edgesuite-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "jfuentes.akamai.com"
    cname_to               = akamai_edge_hostname.jfuentes-akamai-com-edgekey-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  rule_format = "latest"
  rules       = data.akamai_property_rules_template.rules.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "jfuentes-newhirelab-com-staging" {
  property_id                    = akamai_property.jfuentes-newhirelab-com.id
  contact                        = ["jfuentes@akamai.com"]
  version                        = var.activate_latest_on_staging ? akamai_property.jfuentes-newhirelab-com.latest_version : akamai_property.jfuentes-newhirelab-com.staging_version
  network                        = "STAGING"
  auto_acknowledge_rule_warnings = true
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "jfuentes-newhirelab-com-production" {
  property_id                    = akamai_property.jfuentes-newhirelab-com.id
  contact                        = ["jfuentes@akamai.com"]
  version                        = var.activate_latest_on_production ? akamai_property.jfuentes-newhirelab-com.latest_version : akamai_property.jfuentes-newhirelab-com.production_version
  network                        = "PRODUCTION"
  auto_acknowledge_rule_warnings = true


  compliance_record {
    noncompliance_reason_no_production_traffic {
      ticket_id = var.ticket_id
    }
  } 
}
