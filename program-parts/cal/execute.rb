$LOAD_PATH << '.'

require 'date'
require 'io/console'
require 'optparse'
require 'csv'
require 'print.rb'
require 'calender.rb'


options = {}
optparse = OptionParser.new do |opts|
	opts.banner = "Usage: opt_parser COMMAND [OPTIONS]"
	 opts.separator  ""
	 opts.separator  "Commands"
	 opts.separator  "     terminal: run calender in terminal"
	 opts.separator  "     interactive: run interactive calender"
	 opts.separator  "     exit: restart server"
	 opts.separator  "Options for terminal"

  opts.on('-m', '--month MONTH_NUMBER',Numeric ,"Enter month") do |month|
    options[:month] = month
  end

  opts.on('-y', '--year YEAR',Numeric ,"Enter year") do |year|
    options[:year] = year
  end

  opts.on('-w', '--DOW START_DAY_OF_WEEK',Numeric, "Enter 0 1 2 3 4 5 6 for S, M, T, W, T, F, S respectively") do |dow|
    options[:dow] = dow
  end

  opts.on('-h', '--holidays HOLIDAYS_LIST' ,"Enter file name csv file should have format .csv and left column dates right column holiday type") do |holiday_file|
    options[:holiday_file] = holiday_file
  end
end
optparse.parse!

module Terminal
	include Print

	 
	# def Terminal.run(options)
	# 	@cal = Calender.new(options) 
	# 	 if !options[:month].nil? & !options[:year].nil?  
	# 			holiday_hash = {}
	# 			(1..12).each {|n| holiday_hash[n] = {}}
	# 		 	if options[:holiday_file]
	# 			 	filename = ""
	# 			 	filename.concat(options[:holiday_file]) 
	# 			 	CSV.foreach(filename) do |row|
	# 			 	    date = Date.parse(row[0])
	# 			 	    holiday_hash[date.month][date.day]	= row[1]
	# 				end
	# 		 	end
	# 	 		@cal.set_holidays(holiday_hash) 
	# 	 		!options[:dow].nil? ? @cal.day_of_week = options[:dow] : @cal.day_of_week = 0
	# 	 		@cal.calender(Print::print_holiday)	 
	# 	 elsif (options[:month].nil? | options[:year].nil?)
	# 			@cal.calender(Print::print_clean)
	# 	 end
	# end
end

 

 case ARGV[0]
 when "terminal"
 		# Terminal.run(options)
 		Terminal::Print.Method
 end