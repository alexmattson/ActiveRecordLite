ActiveRecord Lite
=================

Demo:
-----
1. Clone me
2. ``$ ruby demo.rb``
3. Enjoy

Summary:
--------
ActiveRecordLite is an exercise in building my own _very_ stripped down version of ActiveRecord.

The purpose was to understand more deeply how ActiveRecord actually works, particularly how ActiveRecord translates associations and queries into SQL.

[![Screenshot](/doc/code_sample.png)](//github.com/amattson21/ActiveRecordLite/)

Usage:
------
```ruby
require_relative 'lib/active_record_lite'

# open database connection
# below command will auto-generate a seeded db/cats.sqlite3
DBConnection.reset
```

Next, define a model:
```ruby
class Human < SQLObject
  self.table_name = 'humans'
  my_attr_accessor :id, :fname, :lname, :house_id

  has_many :cats, foreign_key: :owner_id
  belongs_to :house
end
```
The table name ``"humans"`` will be will be overridden since our program defaults to ``"humen"`` and we do not want that.
To override the default, call ``self.table_name = "new_name"``

By using ``my_attr_accessor``, we allow mass-assignment:
```ruby
devon = Human.new(fname: 'Devon', lname: 'Watts', house_id: 1)
```

The ``foreign_key`` for ``has_many :cats`` is auto-generated to be ``:human_id``. This is wrong in the case of our seed data.
For this reason ``has_many`` and ``belongs_to`` associations accept overrides for ``:class_name``, ``:foreign_key``, and `:primary_key`:
```ruby
has_many :cats,
foreign_key: :owner_id,
class_name: 'Cat',
primary_key: :id
```


Last, there is support for ``has_one_through``:
```ruby
class Cat < SQLObject
  set_table_name 'cats'
  my_attr_accessor :id, :name, :owner_id

  belongs_to :human, foreign_key: :owner_id
  has_one_through :house, :human, :house
end
```
and ``has_many_through``:
```ruby
class House < SQLObject
  my_attr_accessor :id, :address

  has_many :humans
  has_many_through :cats, :humans, :cats
end
```

---
Developed by [Alex Mattson](http://www.alexmattson.com)
