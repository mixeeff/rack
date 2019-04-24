class App
  VALID_PARAMS = {"year" => "%Y", "month" => "%m", "day" => "%d",
                  "hour" => "%H", "minute" => "%M", "second" => "%S"}.freeze

  def call(env)
    parse_params(env)
    [ @status, headers, body ]
  end

  private

  def parse_params(env)
    unless env["REQUEST_PATH"] == "/time"
      @status = 404
      return
    end
    time_params = Rack::Utils.parse_nested_query(env["QUERY_STRING"])["format"].downcase.split(",")
    return unless time_params
    time_format = []
    @wrong_params = []
    time_params.each do |param|
      if VALID_PARAMS[param]
        time_format << VALID_PARAMS[param]
      else
        @wrong_params << param
      end
    end

    @time = Time.now.strftime(time_format.join('-'))
    if @wrong_params.empty?
      @status = 200
    else
      @status = 400
    end
  end

  def headers
    { 'Content-Type' => 'text/html' }
  end

  def body
    return ["404 Not found"] if @status == 404
    result = []
    result << @time if @time
    unless @wrong_params.empty?
      result << "<br>"
      result << "Unknown time format [#{@wrong_params.join(', ')}]"
    end
    result
  end

end
