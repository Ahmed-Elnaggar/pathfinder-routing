require 'httparty'
require 'json'
require 'sinatra/base'
require 'sinatra/config_file'
require 'thread'
require 'timeout'

class MasterRouter < Sinatra::Base
  register Sinatra::ConfigFile

  config_file 'config.yml'

  def compute_distance(routes, distances)
    total = 0
    routes.each do |route|
      route.each_cons(2) do |a, b|
        if distances[a-1].nil? or distances[a-1][b-1].nil?
          puts "Distances does not include #{a}, #{b}"
        else
          total = total + distances[a-1][b-1]
        end
      end
    end
    total
  end

  post '/' do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    distances = request_payload['distances']
    puts "Route request received with distances #{distances}"

    threads = []
    puts "Sending work to: #{settings.workers}"
    settings.workers.each do |u|
      threads << Thread.new {
        begin
          Thread.current[:output] = HTTParty.post(u, {
            :body => request_payload.to_json,
            :headers => { 'Content-Type' => 'application/json' },
            :timeout => settings.timeout
          }).parsed_response
        rescue StandardError => e
          puts 'Bad or missing response from worker'
          puts e.message
          Thread.current[:output] = nil
        end
      }
    end

    best_route = nil
    best_distance = nil
    threads.each do |t|
      t.join
      unless t[:output].nil? or t[:output]["routes"].nil?
        route = t[:output]
        distance = compute_distance(route["routes"], distances)
        puts "Got route response: #{route} with distance #{distance}"
        if best_distance.nil? or distance < best_distance
          best_distance = distance
          best_route = route
        end
      end
    end
    puts "Distance: #{best_distance.to_s}"
    best_route = if best_route.nil? then {routes: []} else best_route end
    best_route.to_json
  end
end
