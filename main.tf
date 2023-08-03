terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "low_cache_hits_count_in_coredns" {
  source    = "./modules/low_cache_hits_count_in_coredns"

  providers = {
    shoreline = shoreline
  }
}