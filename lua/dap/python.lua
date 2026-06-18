return {
	type = "executable",
	command = require("utils").python_path(),
	args = { "-m", "debugpy.adapter" },
}
