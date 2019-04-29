require_relative 'params_parser'
class App
  def call(env)
  	params = get_params(env)
  	return empty_params unless params

  	parser = ParamsParser.new(params)

  	if parser.valid?
  		formatted_time(parser.time_format)
  	else
  		error_in_params(parser.errors)
  	end
  end

  private

  def get_params(env)
  	Rack::Utils.parse_nested_query(env["QUERY_STRING"])["format"]
  end

  def formatted_time(format)
  	status = 200
  	body = ["Current time is #{Time.now.strftime(format.join('-'))}"]
  	[ status, headers, body ]
  end

  def error_in_params(errors)
  	status = 400
  	body = ["Unknown time format [#{errors.join(', ')}]"]
  	[ status, headers, body ]
  end

  def empty_params
    status = 400
    body = ["Format didn't specified"]
  	[ status, headers, body ]
  end

  def headers
  	{ 'Content-Type' => 'text/plain' }
  end
end
