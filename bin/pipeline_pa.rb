#!/usr/bin/env ruby
puts RUBY_VERSION

require "advance"
require "clip_to_region"

up_rgt = [37.82958198283902, -122.34580993652342]
bt_lft = [37.79269371351246, -122.27800369262694]

include Advance

ensure_bin_on_path

def c0(key); $cols.index(key); end
def c1(key); c0(key) + 1; end

advance :single, :scrape_purple_air, "pa_scrape_sensors.rb sensors.csv"
$cols = %i{ name lat lng id_1 id_2 }
required_cols = %i{ lat lng }
required_cols_expression = required_cols.map{|col| "!row[#{c0(col)}].nil?"}.join(" && ")
advance :multi, :remove_bad_records, "csv_select_nh.rb '#{required_cols_expression}' {input_file} > {file_name}"
advance :single, :clip_to_region_of_interest, "csv_select_nh.rb #{clip_to_region(up_rgt, bt_lft, :lat, :lng)} {input_file} > clipped_sensor_list.csv"
