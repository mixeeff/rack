class ParamsParser
	VALID_PARAMS = {"year" => "%Y", "month" => "%m", "day" => "%d",
                  "hour" => "%H", "minute" => "%M", "second" => "%S"}.freeze
	def initialize(app)
		@app = app
    @time_format = []
    @wrong_params = []
	end

	def call(env)
		@status, @headers, @body = @app.call(env)
		parse_params(env)
    set_body_and_status
		[@status, @headers, @body]
	end

	def parse_params(env)
  	time_params = Rack::Utils.parse_nested_query(env["QUERY_STRING"])["format"]

    unless time_params
      @status = 400
      return
    end

    time_params = time_params.downcase.split(",")
		time_params.each do |param|
  		if VALID_PARAMS[param]
    		@time_format << VALID_PARAMS[param]
  		else
    		@wrong_params << param
  		end
    end
  end

  def set_body_and_status
    if @time_format.empty?
      @body << "Format didn't specified"
      @status = 400
      return
    end
		time = Time.now.strftime(@time_format.join('-'))
    @body << "Current time is #{time}"
    unless @wrong_params.empty?
        @status = 400
  			@body  << "\n"
  			@body  << "Unknown time format [#{@wrong_params.join(', ')}]"
		end
  end

end
