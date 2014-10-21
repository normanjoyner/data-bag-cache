action :get do
    # set data bag name
    if new_resource.data_bag.nil?
        data_bag = new_resource.name
    else
        data_bag = new_resource.data_bag
    end

    # initialize result for when cached_disabled = true
    result = nil

    # check if search query is specified
    if new_resource.search.nil?
        key = data_bag
        result = check_cache(key) unless new_resource.cache_disabled

        # data bags not cached ... searching
        if result.nil?
            result = search(data_bag.to_sym)
            store_cache(key, new_resource.name)
        end
    else
        key = "#{data_bag}#{new_resource.search}"
        result = check_cache(key) unless new_resource.cache_disabled

        # data bags not cached ... searching
        if result.nil?
            result = search(data_bag.to_sym, new_resource.search)
            store_cache(key, new_resource.name)
        end
    end

    # save data bags as requested name
    node.default['data-bag-cache'][new_resource.name] = result

    # resource was updated
    new_resource.updated_by_last_action(true)
end

require "digest"

# check if request is stored in cache
def check_cache(key)
    checksum = Digest::MD5.hexdigest(key)
    node['data-bag-cache'][node['data-bag-cache']['__checksums__'][checksum]]
end

# store cache for future use
def store_cache(key, name)
    checksum = Digest::MD5.hexdigest(key)
    node.default['data-bag-cache']['__checksums__'][checksum] = name
end
