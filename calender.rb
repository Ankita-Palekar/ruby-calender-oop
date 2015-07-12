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
		@week_days.map {|wday| print wday, "    "}
		print "\n"
		flush_output
	end

	def print_prev_fake(num)
		for i in 0..(num - 1)
			print "     "
		end
	end

	def display_dates
		#calender fully dependent on the current_start_date
		date = @current_start_date 
		#logic to calc previous pseudo dates
		prev_fake_month_days = @current_start_date.wday  
		strt_ptr = date.wday
		print_prev_fake(strt_ptr)

		for week in 0..5
			for day in strt_ptr..6
				(date.day < 9) ? (print date.day, "    ") : (print date.day,"   ")
				date += 1 
				break if date.month != @current_start_date.month
				# if day == date.wday
				# 	(date.month == @current_start_date.month)	? (print date.day) : (print "*", date.day)		
				# 	((date.day < 9) & (date.month == @current_start_date.month)) ? ( print "    ") :( print "   ")
				# 	date +=1	
				# else
				# 	 print "*", (@current_start_date - prev_fake_month_days).day , "  "
				# 	 prev_fake_month_days -= 1
				# end
			end
			strt_ptr = 0
			print "\n"
		end

		# print_next_fake()

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


############################################
#
#
#
#
# 										July  2015
# 				S    M    T    W    T    F    S    
# 				*28  *29  *30  1    2    3    4    
# 				5    6    7    8    9   10   11   
# 				12   13   14   15   16   17   18   
# 				19   20   21   22   23   24   25   
# 				26   27   28   29   30   31   *1   
# 				*2   *3   *4   *5   *6   *7   *8   
