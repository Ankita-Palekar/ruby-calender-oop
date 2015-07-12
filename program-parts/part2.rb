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

	def print_prev_null(num)
		for day in 0..(num - 1)
			print "     "
		end
	end

	def prev_month_fake_display(num_previous_fake)
		  num_days = num_previous_fake
		for day in 0..(num_previous_fake-1)
			print "*", (@current_start_date-num_days).day, "  "
			num_days -= 1
		end
	end

	# def next_month_fake_display(last_week_num, last_day)
	# 	next_month_start_date = @current_start_date >> 1
	# 	for week in last_week_num..5
	# 		for day in last_day..6
	# 			print "*", next_month_start_date.day, " "
	# 			next_month_start_date += 1
	# 		end
	# 		print "\n"
	# 		last_day = 0
	# 	end
	# end

	def display_day_names
		@week_days.map {|wday| print wday, "    "}
		print "\n"
		flush_output
	end

	def display_dates
		date = @current_start_date 	 
		strt_ptr = date.wday
		prev_month_fake_display(strt_ptr)

		for week in 0..5
			for day in strt_ptr..6
				if date.month == @current_start_date.month #condition checks if new month started
					(date.day < 9) ? (print date.day, "    ") : (print date.day,"   ")
				else
					print "*", date.day ,"   "
				end
				date += 1 
			end
			strt_ptr = 0
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
 