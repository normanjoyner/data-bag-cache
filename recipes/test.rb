# get users
data_bag_cache_items "users"

puts node['data-bag-cache']['users']
