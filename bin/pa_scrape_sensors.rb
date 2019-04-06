#!/usr/bin/env ruby

require "cgi"
require "csv"
require "nokogiri"
require "open-uri"
require "uri"

csv_output_file = ARGV[0]

doc = Nokogiri::HTML(open('https://www.purpleair.com/sensorlist'))

# for testing
# doc = Nokogiri::HTML(File.read("sensorlist"))

CSV.open(csv_output_file, "w") do |output_csv|
  doc.css("div#thelist tr").each do |sensor_row|
    columns = sensor_row.css("td")
    name = columns[1].css("b").text.strip
    sensor_id_1, sensor_id_2 = columns[0].at("input[name=p_sensor]").attribute("value").value.split("|")
    anchor = columns[3].at("a")
    lat = lng = nil
    if anchor
      query_params = CGI::parse(URI(anchor.attribute("href").value).query)
      lat = query_params["lat"].first
      lng = query_params["lng"].first
    end
    output_csv << [name, lat, lng, sensor_id_1, sensor_id_2]
  end
end
