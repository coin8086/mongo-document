# Mongo Document
A helper for defining model class for MongoDB Ruby Driver. 
Blog post for it:  http://huiming.io/2016/10/07/mongo-document.html

# Why do I need it?
1. You want something simple yet powerfull - The `mongo` Gem seems fit, but you can't build model class like `Mongoid` does with it.
2. However you don't want to turn to Mongoid since it's far away from the simple `mongo`.

`mongo-document` is just such a tiny helper for `mongo` that enables you to build model class like `Mongoid` does.

# Installation
```
gem install mongo-document
```

# Usage

```ruby
require 'mongo/document'

Mongo::Document.establish_connection(
  :hosts => ["localhost:27017"],
  :database => "mongo-document-test",
)

class User
  include Mongo::Document
  
  indexes.create_many([
    { :key => { :email => 1 }, :unique => true, :sparse => true },
    { :key => { :type => 1 }},
  ])
end

User.insert_one(:email => 'a@b.com', :type => 'dev', :name => 'Bob')
users = User.find(:email => 'a@b.com')
...

```

The model class `User` defines a collection named `users`. The mapping from class name to collection name conforms to the behaviour of ActiveRecord. You can override this by explicitly naming the collection like:

```ruby
class User
  include Mongo::Document
  
  self.collection_name = 'old_users'
end

```

The model class `User` has all public methods defined in `Mongo::Collection` by `mongo` Gem. In fact the former forwards those method calls to the latter. You use the model class just as a `Mongo::Collection` object!

Before you call any methods of a `Mongo::Collection` object, you need to call `Mongo::Document.establish_connection` first. It takes a singel hash parameter, in which a `hosts` or a `uri` field must be provided. The `uri` conforms to the MongoDB document: https://docs.mongodb.com/manual/reference/connection-string/. The other fields of the `spec` hash are optional and documented in: https://docs.mongodb.com/ruby-driver/v2.2/tutorials/ruby-driver-create-client/#ruby-driver-client-options

What's more, if you have a config file `config/database.yml` under the current working directory, it will be read for a call to `Mongo::Document.establish_connection` automatically. That's a Rails/Rack convention. You can disable this behaviour by setting environment variable `MD_NO_AUTO_CONFIG=1`. The format of the file is like:

```yaml
development:
  hosts:
    -- localhost:27017
  database: dev-db
  
test:
  hosts:
    -- localhost:27017
  database: test-db
```

The parameters are documented as mentioned above for `Mongo::Document.establish_connection`.

# Very Light Footprint

You're encouraged to open the single source file to see how slim the implementation is! Total code is less than 100 lines!
