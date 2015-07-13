module Print
	space = " "

	def Print.Method
		print "Hell00"
	end

	print_sample  = Proc.new do |date, month|
		# print @@holidays
		print  "legend = ", @legend, "  ", date, " month=", month
	end

	# to print clean month 
	print_clean = Proc.new do |date, current_date|
		if date.month != current_date.month
			print space * 7
		else
			(date.day <= 9 )? (print date.day, space * 6) 
			: ( print date.day, space * 5	) 
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
				if @holidays[date.month].has_key?(date.day)
					@holiday_list[@holiday_legend_counter] = @holidays[date.month][date.day]	
					print "-",@holiday_legend_counter 
					@holiday_legend_counter  = @holiday_legend_counter.next
				end
			(date.day <= 9 )? ( print date.day, space * 8) 
			: ( print date.day, space * 7) 
		end
	end
end
