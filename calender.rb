require 'date'
require 'io/console'

class Calender
	 
	def initialize
		@today = Date.today()
		@week_days = ['S',  'M',  'T',   'W', 'T', 'F', 'S']
		month = @today.month
		year = @today.year
		@current_start_date = Date.new(year,month,1)
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
		@week_days.map {|wday| print wday, "   "}
		print "\n"
		flush_output
	end

	def display_dates
		#calender fully dependent on the current_start_date
		date = @current_start_date 
		for week in 0..5
			for day in 0..6
				if day == date.wday
					print date.day					
					if date.day < 9
						print "   "
					else
						print "  "
					end
					date +=1	
				else
					print "    "
				end
				break if date.month != @current_start_date.month
			end
			print "\n"
		end
		print "\n"
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
	@cal = Calender.new
	@cal.flush_output
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
end

calender_calculator
