
require 'rubygems'
require 'sinatra'

get '/projects/test/issues.json' do
  <<JSON
  {
    "issues": [ {
      "created_on":"2011/09/06 13:16:43 +0200",
      "status": {
        "name":"New",
        "id":1
      },
      "category": {
        "name":"Frontend",
        "id":45
      },
      "author": {
        "name":"Gregor Weckbecker",
        "id":13
      },
      "project": {
        "name":"Project",
        "id":71
      },
      "subject":"Test",
      "updated_on":"2011/09/06 19:09:29 +0200",
      "tracker": {
        "name":"Bug",
        "id":1
      },
      "start_date":"2011/09/06",
      "description":"",
      "id":3125,
      "done_ratio":0,
      "fixed_version": {
        "name":"1.0 Abgabe",
        "id":158
      },
      "priority": {
        "name":"Normal",
        "id":4
      }
    }],
    "limit":25,
    "total_count":1,
    "offset":0
  }
JSON
end
