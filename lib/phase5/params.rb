require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}
      @params.merge!(route_params)
      if req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      end
      if req.body
        @params.merge!(parse_www_encoded_form(req.body))
      end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      key_val_pairs = URI.decode_www_form(www_encoded_form)
      # ^an array of [key, val] arrays
      params = {}
      
      key_val_pairs.each do |pair|
        parsed_key = parse_key(pair[0])
        val = pair[1]
        current = params
        
        parsed_key[0..-2].each do |key_level|
          current[key_level] ||= {}
          current = current[key_level]
        end
        
        current[parsed_key[-1]] = val
      end
      
      params    
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
