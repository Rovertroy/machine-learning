###
### server.pp, create mariadb database, with user permissions.
###
class mariadb::server {
    ## local variables
    $run              = $::mariadb::run
    $db_host          = $::mariadb::allow_host
    $db               = $::mariadb::name
    $db_user          = $::mariadb::username
    $db_pass          = $::mariadb::password
    $provisioner      = $::mariadb::provisioner
    $provisioner_pass = $::mariadb::provisioner_password
    $tester           = $::mariadb::tester
    $tester_pass      = $::mariadb::tester_password
    $root_pass        = $::mariadb::root_password
    $bind_address     = $::mariadb::bind_address

    ## mysql::server: install, and configure mariadb-server
    ##
    ## @password_hash, default password (can be adjusted via cli)
    ## @max_connections_per_hour, @max_queries_per_hour, @max_updates_per_hour,
    ## @max_user_connections, a zero value indicates no limit
    ##
    class { '::mysql::server':
        service_enabled => $run,
        package_name    => 'mariadb-server',
        root_password   => $root_pass,
        users         => {
            "${db_user}@${db_host}"     => {
                ensure                   => 'present',
                max_connections_per_hour => '0',
                max_queries_per_hour     => '0',
                max_updates_per_hour     => '0',
                max_user_connections     => '0',
                password_hash            => mysql_password($db_pass),
            },
            "${provisioner}@${db_host}" => {
                ensure                   => 'present',
                max_connections_per_hour => '1',
                max_queries_per_hour     => '0',
                max_updates_per_hour     => '0',
                max_user_connections     => '1',
                password_hash            => mysql_password($provisioner_pass),
            },
            "${tester}@${db_host}" => {
                ensure                   => 'present',
                max_connections_per_hour => '0',
                max_queries_per_hour     => '0',
                max_updates_per_hour     => '0',
                max_user_connections     => '1',
                password_hash            => mysql_password($tester_pass),
            },
        },
        grants        => {
            "${db_user}@${db_host}/${db}.*"     => {
                ensure     => 'present',
                options    => ['GRANT'],
                privileges => ['INSERT', 'DELETE', 'UPDATE', 'SELECT'],
                table      => "${db}.*",
                user       => "${db_user}@${db_host}",
            },
            "${provisioner}@${db_host}/${db}.*" => {
                ensure     => 'present',
                options    => ['GRANT'],
                privileges => ['INSERT', 'CREATE'],
                table      => "${db}.*",
                user       => "${provisioner}@${db_host}",
            },
            "${tester}@${db_host}/${db}.*" => {
                ensure     => 'present',
                options    => ['GRANT'],
                privileges => ['SELECT', 'DROP'],
                table      => "${db}.*",
                user       => "${tester}@${db_host}",
            },
        },
        databases     => {
            $db => {
                ensure  => 'present',
                charset => 'utf8',
            },
        },
        override_options => {
            'mysqld' => {
                'bind-address' => $bind_address,
            }
        },
    }
}
