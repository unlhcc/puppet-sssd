#
# Class: sssd
#

class sssd (
    $cache_credentials        = false,
    $client_idle_timeout      = undef,
    $entry_cache_timeout      = undef,
    $entry_negative_timeout   = undef,
    $enumerate                = false,
    $ldap_uri                 = 'ldap://ldap.example.org',
    $ldap_base                = 'dc=example,dc=org',
    $ldap_user_search_base    = undef,
    $ldap_group_search_base   = undef,
    $ldap_tls_reqcert         = undef,
    $ldap_tls_cacert          = undef,
    $ldap_tls_cacertdir       = undef,
    $ldap_id_use_start_tls    = undef,
    $refresh_expired_interval = undef,
    ) {

    package { 'sssd': ensure => present, }

    service { 'sssd':
        ensure     => running,
        name       => 'sssd',
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['sssd'],
        subscribe  => File['sssd.conf'],
    }

    file { 'sssd.conf':
        path    => '/etc/sssd/sssd.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Package['sssd'],
        content => template('sssd/sssd.conf.erb'),
    }

}
