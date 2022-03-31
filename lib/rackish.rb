#!/usr/bin/env ruby
# Id$ nonnax 2022-03-31 11:11:26 +0800
require 'rack'

module Rackish
  @routes = {}
  class << self
    attr :routes
    def push(method, path, **params, &block)
     res = Rack::Response.new block
     routes[[method, path]] = {response: res.finish, params: params}
    end

    def get(path, **params, &block) push('GET', path, **params, &block) end
  end
end

class App
  attr :env, :req, :res
  def routes() ::Rackish.routes end
  def _call(env)
    if match = routes[env.values_at('REQUEST_METHOD', 'PATH_INFO')]
      _, _, body = match[:response]
      res.write instance_exec(req.params.merge(match[:params]), &body)
      return res.finish
    end
    
    [200, {}, ['Not Found']]
  end
  def call(env)
    @env=env
    @req=Rack::Request.new(env)
    @res=Rack::Response.new
    dup._call(env)
  end
end
# 
module Kernel
  def get(path, **params, &block) ::Rackish.get(path, **params, &block)  end
end
  
