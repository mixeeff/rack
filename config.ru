require_relative 'middleware/url_check'
require_relative 'app'

use URLCheck
run App.new
