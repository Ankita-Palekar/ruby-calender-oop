require 'optparse'

options = {}

optparse = OptionParser.new do |opts|

  opts.on('-m', '--month MONTH_NUMBER', "Enter month") do |month|
    options[:month] = month
  end

  opts.on('-y', '--year YEAR', "Enter year") do |year|
    options[:year] = year
  end
end
optparse.parse!
 
 if !options[:month].nil? & !options[:year].nil? 
 		puts "calender if month and year"
 else
 		puts 
 end