#!/usr/bin/ruby1.9.1

require 'optparse'
require 'yaml'

hash = {
  'base' => 
  { 'name' => 'hoge',
    'getPageNum' => '10',
  },
  'detail' =>
  {
     'keiyakuKoshin' => '1',
  }
}

yaml = YAML.load(hash.to_yaml)

p yaml.class
p yaml["base"]["name"]
