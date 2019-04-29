class ParamsParser
  VALID_PARAMS = {"year" => "%Y", "month" => "%m", "day" => "%d",
                    "hour" => "%H", "minute" => "%M", "second" => "%S"}.freeze

  attr_reader :errors, :time_format

  def initialize(params)
    @errors = []
  	@time_format = []
  	parse_params(params)
  end

  def parse_params(params)
  	return unless params
  	params = params.downcase.split(",")
  	params.each do |param|
      if VALID_PARAMS[param]
        @time_format << VALID_PARAMS[param]
      else
    		@errors << param
      end
    end
  end

  def valid?
  	@time_format.any? && @errors.empty?
  end
end
