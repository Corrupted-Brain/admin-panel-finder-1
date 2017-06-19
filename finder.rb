#!/usr/bin/ruby
require 'net/http'

def banner
	puts "#{"=" * 40}"
	puts " Admin Panel Finder v0.1"
	puts " Author: Gr3atWh173"
	puts "#{"=" * 40}"
end

def usage 
	banner
	puts "USAGE: #{File.basename($0)} <http://www.example.com> <dictionary.file>"
end

def check_page(page)
#	puts "[CHECKING] #{page}"
	uri = URI(URI.encode(page))
	result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }
	if result.code != "404" then puts "[FOUND] #{page}"; @found << page end
end

# main

if ARGV.length == 0 then usage; exit end

################## GLOBAL PARAMS #########################
host = ARGV[0]
file = ARGV[1]
@found = []
##########################################################

if ARGV.include? "help" then usage; exit end
if !host.length == 2 then usage; puts "enter host and dictionary file!"; exit end
if !File.file? file then usage; puts "Dictionary file not found!"; exit end
if !host.include? "http://" then host = "http://" + host end

trap("SIGINT") do exit end
banner

puts "Crawling #{host}"
File.open(file, "r").each_line do |f|
	page = host + "/" + f
	
	if page.include? "%EXT%" then 
		check_page(page.gsub("%EXT%", "php"))
		check_page(page.gsub("%EXT%", "asp"))
		check_page(page.gsub("%EXT%", "aspx"))
	else
		check_page(page)
	end
end

puts "Pages Found: "
found.each do |f| puts f end
puts "Admin Finder Exiting..."
exit
