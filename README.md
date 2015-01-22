# ActionAuditor

Allows to record models changes. It offer observers to store ActiveRecord models changes, but you are free to write your own.
There is also mixins for your controllers, but it isn't mandatory too.

We split all changes into actions. Action can be rails controller action or resque/sidekiq/rake task.
Every action can have unlimited number af attributes. For controller action it can be current user id, response status and anything else.

There are thee main items in action_auditor structure:

* ActionObserver
* ModelsObserver
* Store

We offer some default implementation for each of them, but your are free to write your own.

ActionsObserver is a class or module, often mixin. It starts ActionAuditor at the beginning of action and stop at the end.
No changes will be stored if ActionAuditor isn't started.
It also stores action attributes. You can use ActionAuditor::Controller for Rails controllers and RescueConcern for resque tasks or write your own.

```ruby
require 'action_auditor/controller_concern'
class ApplicationController < ActionController::Base
  include ActionAuditor::ControllerConcern
end
```

ModelsObserver observe model changes and trigger ActionAuditor to to store them.
To observe ActiveRecord changes your should add to config/application.rb

```ruby
config.after_initialize do
  require 'action_auditor/ar'
  ActionAuditor::Ar.observe [MyModel1, MyModel2]
end
```

You can add this code for correct work after code reloading in development into config/environment/development.rb

```ruby
ActionDispatch::Reloader.to_prepare do
  ActionAuditor::Ar.observe [MyModel1, MyModel2]
end
```

You could write you own observer for non-ActiveRecord models.

The last part of the system is Store. We provide default store that save data to log file,
but this gem were invented to store data to Postgres database. We don't privide such
store becase it depends on how do your want to analize this data. You can set up the store in initializer with

```ruby
ActionAuditor.store = YourStore.new
```

If you want to see some info logs from this gem you should also configure the logger
```ruby
ActionAuditor.logger = Rails.logger
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
