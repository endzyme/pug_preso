class profiles::apache_web_server {
  include '::apache'
  include ::install_my_website
  # Class['::apache'] -> Class['install_my_website'] ~> Service['apache2']
}
