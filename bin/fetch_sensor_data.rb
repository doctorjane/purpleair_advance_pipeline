#!/usr/bin/env ruby
require "csv"
require "date"

$col_names = ARGV[0].split(",").map(&:to_sym)
def c0(key); $col_names.index(key); end
sensor_list_file = ARGV[1]
start_date = Date.parse(ARGV[2])
end_date = Date.parse(ARGV[3])

# $cols = %i{ name lat lng id_1 id_2 }
# https://thingspeak.com/channels/511581/feed.csv?api_key=QQ7HDZJTJ86BRRNF&offset=0&average=&round=2&start=2019-04-01%2000:00:00&end=2019-04-02%2000:00:00
# https://thingspeak.com/channels/653578/feed.csv?api_key=QQ7HDZJTJ86BRRNF&offset=0&average=&round=2&start=2019-02-01%2000:00:00&end=2019-02-15%2000:00:00
def do_cmd(cmd)
  puts "doing >#{cmd}<"
  output = `#{cmd}`
  status = $?
  if !status.success?
    raise "'#{cmd}' failed with #{status}\n#{output}"
  end
  output
  sleep 5
end

def pa_url(id, start_date, end_date)
  "https://thingspeak.com/channels/#{id}/feed.csv?api_key=QQ7HDZJTJ86BRRNF&offset=0&average=&round=2&start=#{start_date}%2000:00:00&end=#{end_date}%2000:00:00"
end

CSV.foreach(sensor_list_file) do |row|
  id_1 = row[c0(:id_1)]
  id_2 = row[c0(:id_2)]
  location_name = "#{id_1}_#{id_2}"

  sensor_1_file_name = "#{location_name}_1"
  start_date.upto(end_date - 1) do |fetch_date|
    url = pa_url(id_1, fetch_date, fetch_date + 1)
    output_file = "#{sensor_1_file_name}-#{fetch_date}.csv"
    do_cmd("wget -O #{output_file} #{url}")
  end

  sensor_2_file_name = "#{location_name}_2"
  start_date.upto(end_date - 1) do |fetch_date|
    url = pa_url(id_2, fetch_date, fetch_date + 1)
    output_file = "#{sensor_2_file_name}-#{fetch_date}.csv"
    do_cmd("wget -O #{output_file} #{url}")
  end
end
