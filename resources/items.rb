actions :get
default_action :nothing

attribute :name, :kind_of => String, :name_attribute => true
attribute :data_bag, :kind_of => String
attribute :search, :kind_of => String
attribute :cache_disabled, :kind_of => [TrueClass, FalseClass], :default => false

def initialize(*args)
    super
    run_action(:get)
end
