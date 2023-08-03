resource "shoreline_notebook" "low_cache_hits_count_in_coredns" {
  name       = "low_cache_hits_count_in_coredns"
  data       = file("${path.module}/data/low_cache_hits_count_in_coredns.json")
  depends_on = []
}

