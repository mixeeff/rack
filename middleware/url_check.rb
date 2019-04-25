class URLCheck
	def initialize(app)
		@app = app
	end

	def call(env)
		if env["REQUEST_PATH"] == "/time"
			@app.call(env)
		else
			[404, { 'Content-Type' => 'text/plain' }, ['Bad URL']]
		end
	end
end
