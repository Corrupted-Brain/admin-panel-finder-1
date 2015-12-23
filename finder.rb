#!/usr/bin/ruby

require 'net/http'
require 'open-uri'

def banner
	puts "#{"=" * 35}"
	puts " Admin Panel Finder v0.1"
	puts " Author: Randeep Singh"
	puts "#{"=" * 35}"
end

def usage 
	banner
	puts "USAGE: #{File.basename($0)} <target> <dictionary.file>"
	puts "Note: You can also use a file thet is hosted on a server"
	puts "that uses 'HTTP' and NOT 'HTTPS'. Just replace the "
	puts "<dictionary.file> with the complete URL of the file you want to use."
	puts "It will first be downloaded and saved in your Temp folder and then used."
end

def check_page(page)
#	puts "[CHECKING] #{page}"
	
	uri = URI.parse(page)
	result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }
	
	if result.code != "404" then 
		puts "[FOUND] #{page}"
		@found << page 
	end
	
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
if !host.include? "http://" then host = "http://" + host end

trap("SIGINT") do exit end
banner

puts "Crawling #{host}"

if File.file? file then 
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
else
	open(file).each_line do |f|
		page = host + "/" + f
		if page.include? "%EXT%" then 
		check_page(page.gsub("%EXT%", "php"))
			check_page(page.gsub("%EXT%", "asp"))
			check_page(page.gsub("%EXT%", "aspx"))
		else
			check_page(page)
		end
	end
end

# puts "Pages Found: "
# found.each do |f| puts f end

if @found.length == 0 then "[NO MATCH] No path to Admin Panel found." else puts "[INFO] #{@found.length} matche(s)" end
puts "Admin Finder Exiting..."
exit
