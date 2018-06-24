provider "nutanix" {
  username = "admin"
  password = "Nutanix/1234"
  endpoint = "10.5.81.134"
  insecure = true
  port     = 9440
}
variable clusterid {
  default = "00056eda-31fe-0b6a-336d-001fc69be30e"
}
resource "nutanix_virtual_machine" "vm1" {
  metadata {
    kind = "vm"
    name = "metadata-name-test-dou"
  }
  name = "test-dou"
  cluster_reference = {
    kind = "cluster"
    uuid = "${var.clusterid}"
  }
  categories = {
    jondemo = "cat"
  }
  num_vcpus_per_socket = 1
  num_sockets          = 1
  memory_size_mib      = 512
  power_state          = "ON"
  nic_list = [{
    subnet_reference = {
      kind = "subnet"
      uuid = "${nutanix_subnet.test.id}"
    }
    ip_endpoint_list = {
      ip   = "192.168.0.10"
      type = "ASSIGNED"
    }
  }]
}
resource "nutanix_subnet" "test" {
  metadata = {
    kind = "subnet"
  }
  name        = "vlan.0.ipam"
  description = "Dou Vlan 0"
  cluster_reference = {
    kind = "cluster"
    uuid = "${var.clusterid}"
  }
  vlan_id     = 0
  subnet_type = "VLAN"
  prefix_length      = 24
  default_gateway_ip = "10.0.0.1"
  subnet_ip          = "10.0.0.0"
  #dhcp_options {
  #  boot_file_name   = "bootfile"
  #  tftp_server_name = "192.168.0.252"
  #  domain_name      = "nutanix"
  #}
  #dhcp_domain_name_server_list = ["8.8.8.8", "4.2.2.2"]
  #dhcp_domain_search_list      = ["nutanix.com", "calm.io"]
}
data "nutanix_virtual_machine" "nutanix_virtual_machine" {
  vm_id = "${nutanix_virtual_machine.vm1.id}"
}
