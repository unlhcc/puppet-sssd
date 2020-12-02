#
# Class: sssd
#

class sssd (
    $services                 = [ 'nss', 'pam' ],
    $access_provider          = undef,
    $cache_credentials        = false,
    $client_idle_timeout      = undef,
    $entry_cache_timeout      = undef,
    $entry_negative_timeout   = undef,
    $enumerate                = false,
    $ldap_uris                = [ 'ldap://ldap.example.org', ],
    $ldap_chpass_uri          = undef,
    $ldap_base                = 'dc=example,dc=org',
    $ldap_user_search_base    = undef,
    $ldap_group_search_base   = undef,
    $ldap_access_filter       = undef,
    $ldap_tls_reqcert         = undef,
    $ldap_tls_cacert          = undef,
    $ldap_tls_cacertdir       = undef,
    $ldap_id_use_start_tls    = undef,
    $refresh_expired_interval = undef,
    $sysconfig                = undef,
    ) {

    package { 'sssd': ensure => present, }

    $ldap_uris_rand = fqdn_rotate($ldap_uris)

    service { 'sssd':
        ensure     => running,
        name       => 'sssd',
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['sssd'],
        subscribe  => File['sssd.conf', 'sysconfig'],
    }

    file { 'sssd.conf':
        path    => '/etc/sssd/sssd.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Package['sssd'],
        content => template('sssd/sssd.conf.erb'),
    }

    file { 'sysconfig':
        path    => '/etc/sysconfig/sssd',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Package['sssd'],
        content => template('sssd/etc.sysconfig.sssd.erb'),
    }

}
