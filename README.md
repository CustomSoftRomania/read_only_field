#ReadOnlyField

## About

ReadOnlyField is a library, currently a plugin for Redmine that adds required fields property to Redmine models.

Let's say we have a few roles here, `Manager`, `Developer`, etc, and we want to allow only managers to update some fields.

```ruby
class Issue < ActiveRecord::Base
    include ReadOnlyField
    include ReadOnlyField::RedmineUserRoles

    has_read_only_field :estimated_hours, :allow => %w(Managers)
end
```

We can also allow multiple roles to edit a field.


```ruby
class Issue < ActiveRecord::Base
    include ReadOnlyField
    include ReadOnlyField::RedmineUserRoles

    has_read_only_field :estimated_hours, :allow => %w(Managers TeamMembers)
end
```

This is working not only with Redmine. If you write your own UserRoles function on the model you want to have read only fields it will work too.

## Todo
- I18N support for error messages
- Make it a gem
- Add multiple authorization support, maybe Devise + Cancan, etc.

## Contributing

```
$ git clone https://github.com/teodor-pripoae/read_only_field plugins/
$ cd plugins/read_only_field
```

To run the test suite locally, run the following command

```
$ bundle exec rake
/Users/toni/.rbenv/versions/1.9.3-p448/bin/ruby -S rspec spec/read_only_field/read_only_field_spec.rb
Using ActiveRecord 3.2.16
==  CreateTestingStructure: migrating =========================================
-- create_table(:issues)
   -> 0.0012s
==  CreateTestingStructure: migrated (0.0014s) ================================

.........

Finished in 0.04251 seconds
9 examples, 0 failures
```
