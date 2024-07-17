# frozen_string_literal: true

run do
	[200, {}, [<<-HTML]]
		<html>
			<head>
				<title>Example</title>
			</head>
			<body>
				<h1>Example</h1>
				<p>This is an example page.</p>
			</body>
		</html>
	HTML
end
