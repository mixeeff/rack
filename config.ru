require_relative 'middleware/url_check'
require_relative 'middleware/params_parser'
require_relative 'app'

use URLCheck
use ParamsParser
run App.new
