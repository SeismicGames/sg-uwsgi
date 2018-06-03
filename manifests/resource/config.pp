define uwsgi::resource::config (
  String           $file_name    = $name,
  Integer          $processes    = 2,
  Optional[String] $socket       = undef,
  String           $gid,
  String           $uid,
  Optional[String] $chdir        = undef,
  Optional[String] $module       = undef,
  Optional[String] $http_socket  = undef,
  Enum['on','off'] $master       = 'on',
  Optional[String] $wsgi_file    = undef,
  String           $plugins_dir,
  String           $plugins,
  Integer          $chmod_socket = 660,

) {
  if ! defined(Class['uwsgi']) {
    fail('You must include the uwsgi base class before using any defined resources')
  }

  if $socket and $http_socket {
    fail('Either socket or http_socket has to be set')
  }

  if($socket == undef) and ($http_socket == undef) {
    fail('Only socket or http_socket can be set, not both')
  }

  if $module and $wsgi_file {
    fail('Either module or wsgi_file has to be set')
  }

  if($module == undef) and ($wsgi_file == undef) {
    fail('Only module or wsgi_file can be set, not both')
  }

  # create ini file
  $defaults = {
    ensure  => present,
    path    => "/etc/uwsgi/apps-available/${file_name}",
    notify  => File["/etc/uwsgi/apps-enabled/${file_name}"],
  }

  $settings = { uwsgi => {
    processes      => $processes,
    gid            => $gid,
    uid            => $uid,
    'plugins_dir'  => $plugins_dir,
    plugins        => $plugins,
    'chmod-socket' => $chmod_socket,
  }}

  # set master
  if ($master == 'on') {
    $master_settings = deep_merge($settings, { uwsgi => { 'master' => 1 }})
  } else {
    $master_settings = $settings
  }

  # set wsgi_file or module
  if $module {
    $module_settings = deep_merge($master_settings, { uwsgi => { 'module' => $module }})
  } else {
    $module_settings = deep_merge($master_settings, { uwsgi => { 'wsgi-file' => $wsgi_file }})
  }

  # set socket or http
  if $socket {
    $final_settings = deep_merge($module_settings, { uwsgi => { 'socket' => $socket }})
  } else {
    $final_settings = deep_merge($module_settings, { uwsgi => { 'http-socket' => $http_socket }})
  }


  create_ini_settings($final_settings, $defaults)

  file { "/etc/uwsgi/apps-enabled/${file_name}":
    ensure => 'link',
    target => "/etc/uwsgi/apps-available/${file_name}",
  } ~>

  Class['uwsgi::service']
}