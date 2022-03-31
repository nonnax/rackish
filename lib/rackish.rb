#!/usr/bin/env ruby
# Id$ nonnax 2022-03-31 11:11:26 +0800
require 'rack'

module Rackish
  @routes = {}
  class << self
    attr :routes

    def push(http_method, path, **params, &block)
     res = Rack::Response.new block
     routes[[http_method, path]] = res.finish
    end

    def get(path, **params, &block) push('GET', path, **params, &block) end
  end
end

class App
  attr :env, :req, :res
  def routes() ::Rackish.routes end
  def _call(env)
    triplet=routes[env.values_at('REQUEST_METHOD', 'PATH_INFO')] 
    if triplet
      _, _, body = triplet
      text = instance_exec(req.params, &body)
      res.write text
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
  
# p r
# env={'REQUEST_METHOD'=>'GET', 'PATH_INFO'=>'/'}
# p r.call(env)
