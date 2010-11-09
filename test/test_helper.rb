require 'rubygems'
require 'test/unit'

gem 'mocha', '0.9.8'
require File.expand_path(File.dirname(__FILE__) + '/../lib/admapper')

CONFIG_OPTS = YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + "/admapper.yml"))).symbolize_keys

USER = CONFIG_OPTS[:username]

GROUP = CONFIG_OPTS[:groupname] || "WEB.HOGANBP"