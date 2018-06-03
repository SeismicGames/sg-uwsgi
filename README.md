# uwsgi

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with uwsgi](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Puppet module to install and configure uWSGI.

## Setup

```puppet
class { 'uwsgi': }
```

## Usage

The base class just installs uWSGI. To use, you will need to set up `uwsgi::resource::config`
as well to configure your uWSGI application. Below is an example for Graphite: 

```puppet
uwsgi::resource::config { 'graphite.ini':
    plugins_dir  => '/usr/lib/uwsgi',
    plugins      => 'python',
    uid          => 'graphite',
    gid          => 'graphite',
    socket       => '/opt/graphite/graphite.sock',
    wsgi_file    => '/opt/graphite/webapp/graphite/graphite_wsgi.py',
    chmod_socket => 666,
    require      => [
      Class['graphite'],
    ],
    notify       => Service['nginx'],
}
```

## Reference

## Limitations

* Currently only tested on Ubuntu 16.04

## Development

Feel free to use as you wish. If you have any suggestions or improvements please let
us know. 