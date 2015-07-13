# $ LOAD_PATH << "."
require 'date'
require 'io/console'
require 'optparse'
require 'csv'
# require 'holiday.rb'

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
	 @@holidays = {}

	def initialize(options)
		if !options[:month].nil? & !options[:year].nil?  
			@current_start_date = Date.new(options[:year], options[:month], 1)
		else
			@today = Date.today()
			@month = @today.month
			@year = @today.year
			@current_start_date = Date.new(@year, @month, 1)
		end
		@week_days = ['S',  'M',  'T',   'W', 'T', 'F', 'S']
		# @current_start_date = Date.new(year,month,1)
		@day_of_week = 0
		(1..12).each {|n| @@holidays[n] = {}}
	end

	def set_holidays(holidays)
		@@holidays = holidays
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

	def print_prev_null(num)
		for day in 0..(num - 1)
			print "     "
		end
	end

	def prev_month_fake_display(num_previous_fake)
		  num_days = num_previous_fake
		for day in 0..(num_previous_fake-1)
			print "*", (@current_start_date-num_days).day, "   "
			num_days -= 1
		end
	end


	def display_day_names

		@week_days.each_with_index { |val, index| print @week_days[(@day_of_week + index) % 6], "     "  }
		print "\n"
		flush_output
	end

	def print_holidays(holiday_list)
		holiday_list.map {|key, value| print key," => ",value,"\n" }
	end

	def display_dates
		date = @current_start_date
		strt_ptr = (date.wday - @day_of_week) >= 0 ? (date.wday - @day_of_week) : (6 - (date.wday - @day_of_week).abs)     
		letter = "a"

		holiday_list = {}
		holidays_exist = (@@holidays.has_key?(date.month)) & !(@@holidays[date.month]).empty?
		
		prev_month_fake_display(strt_ptr)
		#first check if holidays for this month exist 
		for week in 0..5
			for day in strt_ptr..6
				if date.month == @current_start_date.month #condition checks if new month started
					 if holidays_exist & @@holidays[date.month].has_key?(date.day)
						 	if !(@@holidays[date.month][date.day].empty?)	
						 		holiday_list[letter] = @@holidays[date.month][date.day]
						 		print "-", letter

						 		letter = letter.next
						 	end
					 end
					(date.day < 9) ? (print date.day, "     ") : (print date.day,"    ")
				else
					print "*", date.day ,"    "
				end
				date += 1 
			end
			strt_ptr = 0
			print "\n"
		end
		print "\n"

		print_holidays(holiday_list)

	end


	def calender
		display_month_year
		display_day_names
		display_dates
	end

#miscallaneous functions
	def flush_output
		STDOUT.flush
	end
end


#Running code using above object 


def calender_calculator
	begin	
		holidays = { 1=> { 26 => "Republic Day"}, 2 => {}, 3 => {}, 4 => {}, 5 => {}, 6 => {}, 7 => { 1 => "some day"}, 8 => {}, 9 => {}, 10 => {12 => "Diwali"}, 11 => {}, 12 => { 25 => "Christmas" }}
		print "Enter start day of week e.g 0 => S, 1 => M \n"
		@cal = Calender.new(options)
		@cal.flush_output
		dow = gets.chomp
		@cal.day_of_week = dow.to_i
		@cal.set_holidays(holidays)
		@cal.calender
			loop  do
				print "Press P for Prev Month calender N next month calender E to Exit \n"
				@cal.flush_output
				input = gets.chomp
				break  if input == 'E'
					if (input == 'P') |(input == 'N')
						@cal.change_current_start(input)
						@cal.calender
					else
						print "Wrong input ----- \n"
					end
			end
	rescue Exception => e
		puts "some erro occured\n"
	end

end
 


# calender_calculator









optparse.parse!
	@cal = Calender.new(options) 
 if !options[:month].nil? & !options[:year].nil?  


 	
	 # initialising holiday array to empty list 
	 # stpe 1 is skipped below since it will be info
	holiday_array = {}
	
	(1..12).each {|n| holiday_array[n] = {}}
 	
 	if options[:holiday_file]
	 	filename = ""
	 	filename.concat(options[:holiday_file]) 
	 	CSV.foreach(filename) do |row|
	 	    date = Date.parse(row[0])
	 	    holiday_array[date.month][date.day]	= row[1]
		end
 	end

 	@cal.set_holidays(holiday_array) 
 	 !options[:dow].nil? ? @cal.day_of_week = options[:dow] : @cal.day_of_week = 0
 	@cal.calender
 elsif (options[:month].nil? | options[:year].nil?)
 		puts optparse
 else
	
	@cal.calender
 end

