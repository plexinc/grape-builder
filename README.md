# Grape::Builder

Use [Builder](https://github.com/jimweirich/builder) templates in [Grape](https://github.com/intridea/grape)!

This gem is completely based on [grape-jbuilder](https://github.com/milkcocoa/grape-jbuilder) which in turn is completely based on [grape-rabl](https://github.com/LTe/grape-rabl).

## Installation

Add this line to your application's Gemfile:

    gem 'grape-builder' 

And then execute:

    $ bundle

<!--Or install it yourself as:-->

<!--    $ gem install grape-builder-->

## Usage

### Require grape-builder

```ruby
# config.ru
require 'grape/jbuilder'
```

### Setup view root directory
```ruby
# config.ru
require 'grape/builder'

use Rack::Config do |env|
  env['api.tilt.root'] = '/path/to/view/root/directory'
end
```

### Tell your API to use Grape::Formatter:: Builder

```ruby
class API < Grape::API
  format :xml
  formatter :xml, Grape::Formatter::Builder
end
```

### Use Builder templates conditionally

Add the template name to the API options.

```ruby
get '/user/:id', builder: 'user.builder' do
  @user = User.find(params[:id])
end
```

You can use instance variables in the builder template.

```ruby
xml.user do
  xml.name(@user.name)
  xml.email(@user.email)j
  xml.project do
    xml.name(@project.name)
  end
end
```

### Use builder templates dynamically

```ruby
get ':id' do
  user = User.find_by(id: params[:id])
  if article
    env['api.tilt.template'] = 'users/show'
    env['api.tilt.locals']   = {user: user}
  else
    status 404
    {'status' => 'Not Found', 'errors' => "User id '#{params[:id]}' is not found."}
  end
end
```

## You can omit .builder

The following are identical.

```ruby
get '/home', builder: 'view'
get '/home', builder: 'view.jbuilder'
```

### Example

```ruby
# config.ru
require 'grape/builder'

use Rack::Config do |env|
  env['api.tilt.root'] = '/path/to/view/root/directory'
end

class UserAPI < Grape::API
  format :xml
  formatter :xml, Grape::Formatter::Builder

  # use Builder with 'user.builder' template
  get '/user/:id', builder: 'user' do
    @user = User.find(params[:id])
  end

  # do not use builder, fallback to the defalt Grape XML formatter
  get '/users' do
    User.all
  end
end
```

```ruby
# user.builder
xml.user do
  xmlname(@user.name)
end
```

## Usage with Rails

Create a grape application.

```ruby
# app/api/user.rb
class MyAPI < Grape::API
  format :xml
  formatter :xml, Grape::Formatter::Builder
  get '/user/:id', builder: 'user' do
    @user = User.find(params[:id])
  end
end
```

```ruby
# app/views/api/user.builder
xml.user do
  xml.name(@user.name)
end
```

Edit your **config/application.rb** and add view path

```ruby
# application.rb
class Application < Rails::Application
  config.middleware.use(Rack::Config) do |env|
    env['api.tilt.root'] = Rails.root.join 'app', 'views', 'api'
  end
end
```

Mount application to Rails router

```ruby
# routes.rb
GrapeExampleRails::Application.routes.draw do
  mount MyAPI , at: '/api'
end
```

## Partials


Use the `partial.render` method to render a partial template

```ruby
# app/views/api/user/index.builder
xml.users do
 @users.each do |u|
    xml << partial.render('user/show', user: u)
 end
end
```

```ruby
# app/views/api/user/show.builder
xml.user do
  xml.name(@user.name)
end
```

## Rspec

See "Writing Tests" in https://github.com/intridea/grape.

Enjoy :)


## Special Thanks

Special thanks to [@milkcocoa](https://github.com/milkcocoa) because this gem is completely based on [grape-jbuilder](https://github.com/milkcocoa/grape-jbuilder).

Also thanks to [@LTe](https://github.com/LTe) since `grape-jbuilder` is based on [grape-rabl](https://github.com/LTe/grape-rabl).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
