#!/usr/bin/env ruby
puts RUBY_VERSION

require "advance"
# require "fileutils"
# require_relative "../lib/region_select"

include Advance

ensure_bin_on_path

def c0(key); $cols.index(key); end
def c1(key); c0(key) + 1; end

advance :single, :scrape_purple_air, "pa_scrape_sensors.rb sensors.csv"
$cols = %i{ name lat lng id_1 id_2 }
