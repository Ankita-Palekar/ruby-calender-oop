# $ LOAD_PATH << "."
require 'date'
require 'io/console'
require 'optparse'
require 'csv'
# require 'holiday.rb'

$holiday_hash = {}
$holiday_list = {}
$holiday_legend_counter = 'a'

options = {}
optparse = OptionParser.new do |opts|
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


class Calender

	attr_accessor  :day_of_week,  :month, :year 

	def initialize(options)		
		if !options[:month].nil? & !options[:year].nil?  
			@current_start_date = Date.new(options[:year], options[:month], 1)
		else
			@today = Date.today()
			@month = @today.month
			@year = @today.year
			@current_start_date = Date.new(@year, @month, 1)
		end
	 	
	 	@holiday_legend_counter = "a"
		@week_days = ['S',  'M',  'T',   'W', 'T', 'F', 'S']
		@day_of_week = 0
	end

	def set_holidays(holidays)
		@holidays = holidays
	end


	def change_current_start(month_counter)
		if month_counter == 'P'
			@current_start_date = @current_start_date << 1
		elsif month_counter == 'N'
			@current_start_date = @current_start_date >> 1
		end
	end

	def display_month_year
		print @current_start_date.strftime('      %B'), "  ", @current_start_date.year
		print "\n"
		flush_output
	end

	def display_day_names
		space = " "
		@week_days.each_with_index { |val, index| print @week_days[(@day_of_week + index) % 7],  space * 8}
		print "\n"
		flush_output
	end

	def display_holidays
		$holiday_list.map {|key, value| print key," => ",value,"\n" }
	end

	def display_dates(print_date)
		date = @current_start_date 
		strt_ptr = (date.wday - @day_of_week) >= 0 ? (date.wday - @day_of_week) : (6 - (date.wday - @day_of_week).abs + 1)
		date = @current_start_date - strt_ptr
		for week in 0..5
			for day in 0..6
				self.instance_exec date, @current_start_date, &print_date
				 
				date += 1
			end
			print "\n"
		end		
	end

	def calender(print_date)
		display_month_year
		display_day_names
		display_dates(print_date)
		display_holidays

	end

#miscallaneous functions
	def flush_output
		STDOUT.flush
	end
end


#Running code using above object 


 

space = " "
# to print clean month 
print_clean = Proc.new do |date, current_date|
	if date.month != current_date.month
		print space * 9
	else
		(date.day <= 9 )? (print date.day, space * 8) 
		: ( print date.day, space * 7	) 
	end
end

# to print pseudo prev and next month

print_pseudo = Proc.new do |date, current_date|
	if date.month != current_date.month
		(date.day <= 9 )? ( print "*", date.day, space * 5) : ( print "*", date.day, space * 4) 
	else
		(date.day <= 9 )? ( print date.day, space * 6) 
		: ( print date.day, space * 5) 
	end
end

#above program modified to add holiday functionlaity

print_holiday = Proc.new do |date, current_date|
	if date.month != current_date.month
		(date.day <= 9 )? ( print "*", date.day, space * 7) : ( print "*", date.day, space * 6) 
	else
			if $holiday_hash[date.month].has_key?(date.day)
				$holiday_list[$holiday_legend_counter] = $holiday_hash[date.month][date.day]	
				print "-",$holiday_legend_counter 
				$holiday_legend_counter  = $holiday_legend_counter.next
			end
		(date.day <= 9 )? ( print date.day, space * 8) 
		: ( print date.day, space * 7) 
	end
end

# def calender_calculator
# 	 options = {}

# 	# begin	
# 		holidays = { 1=> { 26 => "Republic Day"}, 2 => {}, 3 => {}, 4 => {}, 5 => {}, 6 => {}, 7 => { 1 => "some day"}, 8 => {}, 9 => {}, 10 => {12 => "Diwali"}, 11 => {}, 12 => { 25 => "Christmas" }}
# 		print "Enter start day of week e.g 0 => S, 1 => M \n"
# 		@cal = Calender.new(options)
# 		@cal.flush_output
# 		dow = 0
# 		@cal.day_of_week = dow.to_i
# 		@cal.set_holidays(holidays)
# 		@cal.calender(print_clean)
# 			loop  do
# 				print "Press P for Prev Month calender N next month calender E to Exit \n"
# 				@cal.flush_output
# 				input = gets.chomp
# 				break  if input == 'E'
# 					if (input == 'P') |(input == 'N')
# 						@cal.change_current_start(input)
# 						@cal.calender(print_clean)
# 					else
# 						print "Wrong input ----- \n"
# 					end
# 			end
# 	# rescue Exception => e
# 		puts "some erro occured\n"
# 	# end

# end
 


# calender_calculator

 
print_sample  = Proc.new do |date, month|
	# print @@holidays
	print  "legend = ", @legend, "  ", date, " month=", month
end


optparse.parse!
	@cal = Calender.new(options) 
 if !options[:month].nil? & !options[:year].nil?  		
	$holiday_hash = {}
	(1..12).each {|n| $holiday_hash[n] = {}}
 	if options[:holiday_file]
	 	filename = ""
	 	filename.concat(options[:holiday_file]) 
	 	CSV.foreach(filename) do |row|
	 	    date = Date.parse(row[0])
	 	    $holiday_hash[date.month][date.day]	= row[1]
		end
 	end
 	@cal.set_holidays($holiday_hash) 
 	 !options[:dow].nil? ? @cal.day_of_week = options[:dow] : @cal.day_of_week = 0

 	@cal.calender(print_holiday)	 
 elsif (options[:month].nil? | options[:year].nil?)
		@cal.calender(print_clean)
 end


