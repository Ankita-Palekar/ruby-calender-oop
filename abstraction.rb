# $ LOAD_PATH << "."
require 'date'
require 'io/console'
require 'optparse'
require 'csv'

lambda_array = []
extra_functionality_array = []
holiday_legend_counter = 'a'
holiday_list = {}

$holiday_hash = {}
space = " "

print_fake = Proc.new do |date,current_date|
	star = ""
	if date.month != current_date.month
		star = "*"
	end
	star
end

print_holiday = Proc.new do |date,current_date| 
	legend_counter = ""
	
	if $holiday_hash[date.month].has_key?(date.day)
		holiday_list[holiday_legend_counter] = $holiday_hash[date.month][date.day]	
		legend_counter = holiday_legend_counter
		holiday_legend_counter  = holiday_legend_counter.next
	end
 	
 	legend_counter
end

print_date_features = Proc.new do |date,current_date| 
	print_string = ""

	lambda_array.each do |print_function|
		print_string.concat(print_function.call date, current_date)
	end
	print_string.concat(date.day.to_s)
	printf("%7s", print_string)
end


print_holiday_list = Proc.new {
	holiday_list.map {|key, value| printf("%15s  ==> %2s \n", key.to_s, value.to_s)} 
	printf("\n")
}	

print_extra_functionlaity = Proc.new{
	extra_functionality_array.each do |functionality|
		functionality.call
	end
}


options = {}
optparse = OptionParser.new do |opts|
  opts.on('-m', '--month MONTH_NUMBER',Numeric ,"Enter month") do |month|
    options[:month] = month
  end

  opts.on('-y', '--year YEAR',Numeric ,"Enter year") do |year|
    options[:year] = year
  end

  opts.on('-w', '--DOW START_DAY_OF_WEEK',Numeric ,"Enter 0 1 2 3 4 5 6 for S, M, T, W, T, F, S respectively") do |dow|
    options[:dow] = dow
  end

  opts.on('-h', '--holidays HOLIDAYS_LIST' ,"Enter file name csv file should have format .csv and left column dates right column holiday type") do |holiday_file|
    options[:holiday_file] = holiday_file
  end

  opts.on('--holidays', '--Set holidays counter'," ") do |holidays|
  	 options[:holidays] = 1
		lambda_array.push(print_holiday)
		extra_functionality_array.push(print_holiday_list)
  end


  opts.on('--otherdays', '--to show other * days', " ") do |otherdays|
		options[:otherdays] = 1
		lambda_array.push(print_fake)
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
 

	def change_current_start(month_counter)
		if month_counter == 'P'
			@current_start_date = @current_start_date << 1
		elsif month_counter == 'N'
			@current_start_date = @current_start_date >> 1
		end
	end

	def display_month_year
		printf("\n\n\n%20s"," ")
		printf("%s  - %2s", @current_start_date.strftime('%B'), @current_start_date.year)
		print "\n"
		flush_output
	end

	def display_day_names
		@week_days.each_with_index { |val, index| 
		printf("%7s", @week_days[(@day_of_week + index) % 7])}
		print "\n"
		flush_output
	end

	def display_dates(print_date)
		date = @current_start_date 
		strt_ptr = (date.wday - @day_of_week) >= 0 ? (date.wday - @day_of_week) : (6 - (date.wday - @day_of_week).abs + 1)
		date = @current_start_date - strt_ptr
		
		for week in 0..5
			for day in 0..6
				print_date.call date, @current_start_date
				# self.instance_exec date, @current_start_date, &print_date 
				date += 1
			end
			print "\n"
		end		
	end

	def calender(print_date)
		display_month_year
		display_day_names
		display_dates(print_date)
	end

#miscallaneous functions
	def flush_output
		STDOUT.flush
	end
end

 
optparse.parse!

def display_holidays(holiday_list)
	holiday_list.map {|key, value| print key," => ",value,"\n" }
end

@cal = Calender.new(options) 

if !options[:month].nil? & !options[:year].nil?  
#lambda function for 
	(1..12).each {|n| $holiday_hash[n] = {}} 	 	
 	
 	if options[:holiday_file]
	 	filename = ""
	 	filename.concat(options[:holiday_file])  	
	 	CSV.foreach(filename) do |row|
	 	    date = Date.parse(row[0])
	 	    $holiday_hash[date.month][date.day]	= row[1]
		end
	end
 	!options[:dow].nil? ? @cal.day_of_week = options[:dow] : @cal.day_of_week = 0
 	@cal.calender(print_date_features)	 
 	print_extra_functionlaity.call
elsif (options[:month].nil? | options[:year].nil?)
	@cal.calender(print_clean)
end


