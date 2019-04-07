#!/usr/bin/env ruby
require "date"
require "json"
require_relative "../lib/script_helpers"

sensor_list_file = ARGV[0]
start_date = Date.parse(ARGV[1])
end_date = Date.parse(ARGV[2])

def pa_url(thingspeak_id, thingspead_read_key, start_date, end_date)
  "https://thingspeak.com/channels/#{thingspeak_id}/feed.json?api_key=#{thingspead_read_key}&offset=0&average=&round=2&start=#{start_date}%2000:00:00&end=#{end_date}%2000:00:00"
end

sensors = JSON.load(File.read(sensor_list_file))
sensors.each do |sensor_info|
  output_file = sensor_info["ParentID"].nil? ? "#{sensor_info['ID']}_A.json" : "#{sensor_info['ParentID']}_B.json"
  start_date.upto(end_date - 1) do |fetch_date|
    url = pa_url(sensor_info["THINGSPEAK_PRIMARY_ID"], sensor_info["THINGSPEAK_PRIMARY_ID_READ_KEY"], fetch_date, fetch_date + 1)
    ScriptHelpers.do_cmd("wget -O #{output_file} #{url}")
    sleep 1
  end
end
