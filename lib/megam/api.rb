require "base64"
require "excon"
require "securerandom"
require "uri"
require "zlib"

__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), ".."))
unless $LOAD_PATH.include?(__LIB_DIR__)
$LOAD_PATH.unshift(__LIB_DIR__)
end

require "megam/api/json/okjson"
require "megam/api/errors"
require "megam/api/version"
require "megam/api/nodes"
require "megam/api/login"
require "megam/api/logs"
require "megam/api/predefs"
require "megam/api/accounts"

srand

module Megam
  class API

    HEADERS = {
      'Accept'                => 'application/json',
      'Accept-Encoding'       => 'gzip',
      'User-Agent'            => "megam-api/#{Megam::API::VERSION}",
      'X-Ruby-Version'        => RUBY_VERSION,
      'X-Ruby-Platform'       => RUBY_PLATFORM
    }

    OPTIONS = {
      :headers  => {},
      :host     => 'api.megam.co',
      :nonblock => false,
      :scheme   => 'http'
    }

   
    
      
    # It is assumed that every API call will use an API_KEY/email. This ensures validity of the person      
    # really the same guy on who he claims.
    # 
    #
    def initialize(options={})
    
      
      options = OPTIONS.merge(options)
       puts options
      

       @api_key = options.delete(:api_key) || ENV['MEGAM_API_KEY']
 
       puts "api key: #{@api_key}"
      
       encoded_api_header = encode_header(options)
      
         puts "encode:#{encoded_api_header}"

      options[:headers] = HEADERS.merge({
        # Now only use the ones needed from encoded_api_header, eg: :hmac, :date
        'Authorization' => "Basic #{Base64.encode64("#{encoded_api_header}").gsub("\n", '')}",
      }).merge(options[:headers])
         
         puts options

        puts options[:headers]

           @connection = Excon.new("#{options[:scheme]}://#{options[:host]}", options)
           #Excon.post('http://',
             #         :headers => {"Content-Type" => "application/json", })

            puts "connection: #{@connection}"
    end

    def request(params, &block)
    
    puts "request called"
    puts "before begin #{params}"
    @query= "#{params[:query]}"  
    @path= "#{params[:path]}"  
    @body= "#{params[:body]}"
    
      puts @query
      puts @path
      puts @body
  

    begin

        response = @connection.request(params, &block)
     
       rescue Excon::Errors::HTTPStatusError => error
        klass = case error.response.status 
        when 401 then Megam::API::Errors::Unauthorized
        when 403 then Megam::API::Errors::Forbidden
        when 404 then Megam::API::Errors::NotFound
        when 408 then Megam::API::Errors::Timeout
        when 422 then Megam::API::Errors::RequestFailed
        when 423 then Megam::API::Errors::Locked
        when /50./ then Megam::API::Errors::RequestFailed
        else Megam::API::Errors::ErrorWithResponse
        end
        reerror = klass.new(error.message, error.response)
        reerror.set_backtrace(error.backtrace)
        raise(reerror)
       puts @connection
      end
      if response.body && !response.body.empty?
        if response.headers['Content-Encoding'] == 'gzip'
          response.body = Zlib::GzipReader.new(StringIO.new(response.body)).read
        end
        begin
          response.body = Megam::API::OkJson.decode(response.body)
        rescue
        end
      end
       
      # reset (non-persistent) connection
      @connection.reset

      response
    end

    private 
    
    
    ## encode header as per rules.    
    # The input hash will have
    # :api_key, :email, :body, :path
      api_key= "#{@query}"
      puts "#{api_key}"
      path= "#{@path}"
      puts "#{path}"
      body= "#{@body}"
      puts "#{body}"
    # The output will have
    # :hmac
    # :date
    # The  :date => format needs to be "yyy-MM-dd HH:mm"  
       #time= Time.new
       #date = time.now.strftime(%Y/%m/%d %H%M) 
      

    def encode_header(cmd_parms)
    
      puts "encode_header calling"  
      puts "#{cmd_parms}" 
      header_params ={}
      
      
      #encode the body (refer calculateMD5) :body_md5
      #build the string to sign (:date + "\n" + :path + "\n" + :body_md5 )
      #build hmac (refer calculateHMAC)
      #build the string :hmac (:email +":"+:calc_hmac)
      #stick stuff in the header_parms and send it back.
      header_params
    end

    def node_params(params)
      node_params = {}
      params.each do |key, value|
        node_params["nodes[#{key}]"] = value
      end
      node_params
    end
  end
end
