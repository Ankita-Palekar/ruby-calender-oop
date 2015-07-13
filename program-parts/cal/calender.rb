# $ LOAD_PATH << "."
require 'date'
require 'io/console'
require 'optparse'
require 'csv'
# require 'holiday.rb'
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
		@holiday_list = {}
		@day_of_week = 0
		@holidays		 =  {}
		(1..12).each {|n| @holidays[n] = {}}
		@@legend = 'A'
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
		@holiday_list.map {|key, value| print key," => ",value,"\n" }
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