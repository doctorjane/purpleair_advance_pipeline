#!/usr/bin/env ruby

require_relative "../lib/script_helpers"

output_file = ARGV[0]
url = "http://www.purpleair.com/json"

ScriptHelpers.do_cmd("wget -O #{output_file} #{url}")
