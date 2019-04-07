#!/usr/bin/env ruby
puts RUBY_VERSION

require "advance"

# up_rgt = [37.82958198283902, -122.34580993652342]
# bt_lft = [37.79269371351246, -122.27800369262694]

up_rgt = [37.811631, -122.206586]
bt_lft = [37.799787, -122.231889]

start_date = "2019-04-01"
end_date = "2019-04-06"

include Advance

ensure_bin_on_path

advance :single, :sensor_list, "sensor_list.rb sensor_list.json"
advance :single, :get_sensor_list_array, 'cat {input_file} | jq ".results" > sensor_list_array.json'
advance :single, :remove_records_with_no_location, 'cat {input_file} | jq "[.[] | select(.Lat != null)]" > clean_sensor_list.json'
advance :single, :clip_to_region_of_interest, "cat {input_file} | jq '[.[] | select(.Lat >= #{bt_lft[0]} and .Lat <= #{up_rgt[0]} and .Lon >= #{bt_lft[1]} and .Lon <= #{up_rgt[1]})]' > clipped_sensor_list.json"
advance :single, :fetch_sensor_data, "fetch_sensor_data.rb {input_file} #{start_date} #{end_date}"
