default_options = {
    :search => nil,
    :data_bag => nil,
    :cache_disabled => false
}

define(:data_bag_cache, default_options) do

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

    # set data bag name
    if params[:data_bag].nil?
        data_bag = params[:name]
    else
        data_bag = params[:data_bag]
    end

    # initialize result for when cached_disabled = true
    result = nil

    # check if search query is specified
    if params[:search].nil?
        key = data_bag
        result = check_cache(key) unless params[:cache_disabled]

        # data bags not cached ... searching
        if result.nil?
            result = search(data_bag.to_sym)
            store_cache(key, params[:name])
        end
    else
        key = "#{data_bag}#{params[:search]}"
        result = check_cache(key) unless params[:cache_disabled]

        # data bags not cached ... searching
        if result.nil?
            result = search(data_bag.to_sym, params[:search])
            store_cache(key, params[:name])
        end
    end

    # save data bags as requested name
    node.default['data-bag-cache'][params[:name]] = result
end
