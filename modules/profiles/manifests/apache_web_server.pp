class profiles::apache_web_server {
  class { '::apache':
    default_vhost => false,
  }
  include ::install_my_website
  # Class['::apache'] -> Class['install_my_website'] ~> Service['apache2']
}
