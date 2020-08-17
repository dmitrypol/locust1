variable "tenancy_ocid" {
  description = "BOAT"
  default     = "ocid1.tenancy.oc1..aaaaaaaagkbzgg6lpzrf47xzy4rjoxg4de6ncfiq2rncmjiujvy2hjgxvziq"
}

variable "user_ocid" {
  default = "ocid1.user.oc1..aaaaaaaalgyhg26ahodudcascngjycpqbg4w6g6qlljrbfrvevbkdipjq5nq"
}

variable "fingerprint" {
  default = "7b:31:59:6b:3a:8f:f9:dc:57:43:27:86:35:16:0a:a2"
}

variable "private_key_path" {
  default = "~/.oci/oci_api_key.pem"
}

variable "region" {
  default = "us-ashburn-1"
}

variable "compartment_id" {
  default = "ocid1.compartment.oc1..aaaaaaaab4ugniiqpmuvbmtct6zjvmw2c6slrnfxdfjmkurbt6iwexbwcyba"
}

variable "vcn_id" {
  default = "ocid1.vcn.oc1.iad.amaaaaaaxqrvatyap66rfvbqw3ierzq7laljizqlublkhbu6f74acrfhveba"
}

variable "public_subnet_id" {
  default = "ocid1.subnet.oc1.iad.aaaaaaaacc4nos2zq6j4loerreczh5f7a2eah2cg5m7w66u7f5xvmudfw5yq"
}

variable "cluster_kubernetes_version" {
  default = "v1.16.8"
}

variable "image_id" {
  description = "Oracle-Linux-7.8-2020.06.30-0"
  default     = "ocid1.image.oc1.iad.aaaaaaaabip6l5i5ikqsnm64xwrw2rrkj3tzo2dv47frowlt3droliwpvfaa"
}

variable "ad_prefix" {
  default = "snpv"
}

provider "oci" {
  version          = ">= 3.89.0"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

resource "oci_containerengine_cluster" default {
  #Required
  compartment_id     = var.compartment_id
  kubernetes_version = var.cluster_kubernetes_version
  name               = "cluster1"
  vcn_id             = var.vcn_id
  #Optional
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled               = true
    }
  }
}

resource "oci_containerengine_node_pool" pool1 {
  #Required
  cluster_id         = oci_containerengine_cluster.default.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.cluster_kubernetes_version
  name               = "pool1"
  node_shape         = "VM.Standard1.1"
  node_source_details {
    image_id    = var.image_id
    source_type = "IMAGE"
  }
  node_config_details {
    placement_configs {
      availability_domain = "${var.ad_prefix}:US-ASHBURN-AD-1"
      subnet_id           = var.public_subnet_id
    }
    placement_configs {
      availability_domain = "${var.ad_prefix}:US-ASHBURN-AD-2"
      subnet_id           = var.public_subnet_id
    }
    placement_configs {
      availability_domain = "${var.ad_prefix}:US-ASHBURN-AD-3"
      subnet_id           = var.public_subnet_id
    }
    size = 1
  }
}

resource "oci_containerengine_node_pool" pool2 {
  #Required
  cluster_id         = oci_containerengine_cluster.default.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.cluster_kubernetes_version
  name               = "pool2"
  node_shape         = "VM.Standard1.1"
  # subnet_ids         = [var.public_subnet_id]
  node_source_details {
    image_id    = var.image_id
    source_type = "IMAGE"
  }
  node_config_details {
    placement_configs {
      availability_domain = "${var.ad_prefix}:US-ASHBURN-AD-1"
      subnet_id           = var.public_subnet_id
    }
    placement_configs {
      availability_domain = "${var.ad_prefix}:US-ASHBURN-AD-2"
      subnet_id           = var.public_subnet_id
    }
    placement_configs {
      availability_domain = "${var.ad_prefix}:US-ASHBURN-AD-3"
      subnet_id           = var.public_subnet_id
    }
    size = 0
  }
  # quantity_per_subnet = "${var.node_pool_quantity_per_subnet}"

  #   #Optional
  #   initial_node_labels {
  #     #Optional
  #     key   = "${var.node_pool_initial_node_labels_key}"
  #     value = "${var.node_pool_initial_node_labels_value}"
  #   }
  #   node_metadata   = "${var.node_pool_node_metadata}"
  #   ssh_public_key      = "${var.node_pool_ssh_public_key}"
}