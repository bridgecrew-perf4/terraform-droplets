variable "do_token" {
  description = "Personal access token"
}
variable "ssh_fingerprint" {
  description = "Fingerprint of your SSH key"
}
variable "droplet_image" {
  description = "OS Image"
  default     = "ubuntu-20-04-x64"
}
variable "droplet_region" {
  description = "Droplet region identifier where the droplet will be created"
  default     = "nyc1"
}
variable "droplet_size" {
  description = "Droplet size identifier"
  default     = "s-1vcpu-1gb"
}