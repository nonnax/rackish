#!/usr/bin/env ruby
# Id$ nonnax 2022-03-31 11:22:16 +0800
require_relative 'lib/rackish'

get '/', name: 'ronald' do |env|
    "hello (#{env})"
end
get '/red' do
  res.redirect 'https://myflixer.to'
end

app=App.new
p app.routes

run app
