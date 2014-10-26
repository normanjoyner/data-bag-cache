data-bag-cache
======

##About

###Description
Temporarily caches Chef data bag items in an attribute to speed up chef-client runs.

###Author
* Norman Joyner - <norman.joyner@gmail.com>

##Getting Started

###Installation
Using Berkshelf: ```cookbook 'data-bag-cache', '~> 0.2.0'```

### Utilization
To use this cookbook, first ensure that you have added ```depends "data-bag-cache"``` to your metadata.rb. Once your cookbook is dependent on data-bag-cache you can cache data bag items using the ```data_bag_cache_items``` definition. The resources available to the definition are listed below:

* ```name``` (required) - name and location of the cached data bag items (name attribute).
* ```data_bag``` (optional) - name of the data bag. Defaults to ```name``` if not provided.
* ```search``` (optional) - a custom search query which will be executed when getting data bag items. Defaults to nil.
* ```cache_disabled``` (optional) - When true, calls to the data_bag_cache_items definition will bypass local cache, and will always perform a new search. Defaults to false.

To access cached data bag items, simply reference the node attribute storing the items. Your items will be located at ```node['data-bag-cache'][definition_name_attribute]```.

### Examples
Get all items in the users data bag:
```ruby
data_bag_cache "users"
```

Get all items in the users data bag where the sysadmin group is present:
```ruby
data_bag_cache "users" do
    search "group:sysadmin"
end
```

Get all items in the users data bag where the shell is /bin/zsh:
```ruby
data_bag_cache "zsh_users" do
    data_bag "users"
    search "shell:/bin/zsh"
end
```

Get all items in the users data bag, ensuring it is the most up to date list (not serving a cached copy from earlier in the run):
```ruby
data_bag_cache "users" do
    cache_disabled true
end
```

Iterating over all items in the users data bag:
``` ruby
node['data-bag-cache']['users'].each do |user|
    puts user.to_json
end
```
