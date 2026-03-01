locals {
  location_short = "uks"
  prefix         = "${var.project}-${var.solution}-${var.environment}-${local.location_short}-${var.service}"
  st_prefix      = lower("${var.project}${var.solution}${var.environment}${local.location_short}${var.service}")
}