terraform init
terraform import akamai_edge_hostname.jfuentes-akamai-cm-edgesuite-net ehn_2689649,ctr_1-1NC95D,grp_231801
terraform import akamai_edge_hostname.jfuentes-akamai-com-edgekey-net ehn_4932258,ctr_1-1NC95D,grp_231801
terraform import akamai_property.jfuentes-newhirelab-com prp_328340,ctr_1-1NC95D,grp_231801,384
terraform import akamai_property_activation.jfuentes-newhirelab-com-staging prp_328340:STAGING
terraform import akamai_property_activation.jfuentes-newhirelab-com-production prp_328340:PRODUCTION
