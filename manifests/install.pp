class uwsgi::install {
  case $::osfamily {
    'Debian': {
      contain ::apt

      $packages = [
        'uwsgi',
        'uwsgi-plugin-python'
      ]

      ensure_packages($packages, {'ensure' => 'present'})
    }

    default: {
      fail("OS family ${::osfamily} is not supported yet.")
    }
  }
}