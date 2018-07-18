# EasyConf

EasyConf, as its name suggest, is a gem for managing application configuration easily. It works really simple; tries to get configuration key from config files you've specified and uses environment variables as fallback. So if configuration key is not found on config files it will look at the environment variables.

You may wonder why I've created this gem. The answer is simple; because convention matters!

I saw lots of applications written buy other awesome developers and I noticed that they are managing their configurations either by using config files or environment variables or even both! As a result of this, in this applications you can see something like  `ENV['foo']` and `Rails.application.config` mixed all around the source of the application. What a mess.

Beside of this complexity your production environment may have some restrictions you don't have on your own development environment. For example, if you are using Heroku you can't use config files to configure your application. Because you have to untrack config files on your VCS unless you have a good reason to track them. By using EasyConf while you can configure your application with config files also you can use environment variables on your production environment and this will give you a good abstraction on configuration!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_conf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_conf

## Usage

#### EasyConf configuration

EasyConf requires its own configuration to determine the source of the configurations etc. For Rails applications, create a file under config directory which looks like;

```ruby
require 'easy_conf'

EasyConf.configure do |config|
  config.lookups = [EasyConf::Lookup::Env, EasyConf::Lookup::Yaml]
  config.decoder = Proc.new { |value| value.upcase }
end
```

For other ruby applications, place this file wherever you want and load it at the top of the application.

#### Accessing configuration keys

After configuration you can use it inside of your code like this;

```ruby
EasyConf.get(:redis_url) # tries to load redis_url from yml or environment variable
EasyConf.read(:redis_url) # alias of get method
EasyConf.app_config.redis_url # another alias for accessing configuration keys
```

You may want to define a global variable or a constant on top level of your application like `easy_conf.rb` configuration file to get keys as method calls.

By constants;

```ruby
CONFIG = EasyConf.app_config # define this constant on top level of your application
```

By global variables;

```ruby
$config = EasyConf.app_config
```

You can get all configuration keys as an array like;

```ruby
EasyConf.keys # [:foo, ...]
```
Or if you want to get your configurations from config files as Hash, you can just do;

```ruby
EasyConf.to_hash # { "foo" => "bar" }
```

## Configuration Keys

**lookups:** Optional, default is `[:env, :yaml]`. List of lookups to be used to fetch the configuration. The lookup is basically the source of the configuration which. EasyConf implements `ENV`, `YAML` and `VAULT` lookups by default. You can also implement your own lookup, for more information about how to implement a lookup, you may have a look at the source of builtin lookups.

**decoder:** Optional. The idea behind of having this key is, having configuration values as Ruby objects. If you set the ENV var FOO as `"--- 1\n...\n"` and set the `decoder` option as `Proc.new { |value| YAML.load(value) }` the return value of EasyConf.app_config.FOO will be `1` as Fixnum instead of String.

## TIPS

#### Configuring Rails Initializers With EasyConf

If you want to use EasyConf to configure your Rails initializers, put EasyConf configuration file to root of your Rails project and require EasyConf file in your `config/application.rb` file. But keep that in your mind, if you require EasyConf on top of your initializer you can't use `Rails.root` while configuring EasyConf anymore. In this case you have to give absolute paths by yourself.

```ruby
...
Bundler.require(*Rails.groups)

require File.expand_path('../easy_conf', __FILE__)

module YourApp
  class Application < Rails::Application
...
```

Then configure EasyConf like;


```ruby
require 'easy_conf'

EasyConf.configure do |config|
  config.config_files    = ["/Users/.../config/config.yml"]
end
```

#### Deploy With AWS Elastic Beanstalk

AWS Elastic Beanstalk is a really good service to deploy applications into AWS. With Elastic Beanstalk you can use a command line interface to deploy your application in minutes. But because lack of information you may struggle to configure your application. The easiest way to configure your application is using environment variables. To set environment variables you can use either AWS Console or AWS CLI. However if you have lots of configurations AWS has a bad news for you! There is a limitation on environment variables. You can use only *4096* characters to set environment variables for your application. If you reach the limitations you may want to use configuration files to configure your application. But remember that we have to untrack our configuration files. The solution is simple; use `ebextensions` to place your config files into your application directory during deployment. Here is a sample extension which reads configuration file from private S3 bucket and writes it into the correct location.

```
files:
  "/opt/elasticbeanstalk/hooks/appdeploy/pre/01a_get_config_yml.sh":
    mode: "000777"
    content: |
      . /opt/elasticbeanstalk/support/envvars

      cd /var/app/ondeck/config
      aws s3 cp $remote_config_file config.yml
```

This little shell script reads the location of config file from environment file, downloads it and writes it into the place where it should be. You have to adjust access policies for your S3 and Elastic Beanstalk user otherwise it can't download the configuration file.

If you think storing configuration files at S3 is not good then you can use some tools like Apache ZooKeeper. For now EasyConf doesn't support it but you can find it in TODO list.

## TODO

1. Write tests
2. Write adapter for ZooKeeper

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meinac/easy_conf.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
