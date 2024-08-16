return function(key)
	if not vim.g.file_exists(".vscode/launch.json") then
		return {}
	end

	local file = io.open(".vscode/launch.json", "r")
	if not file then
		return {}
	end

	local configs = vim.json.decode(file:read("*all"))["configurations"]
	for _, config in pairs(configs) do
		if config["module"] == "pytest" then
			return config[key]
		end
	end
end
