return function(cmdstr)
	for i = 1, vim.v.count1 do
		vim.cmd(cmdstr)
	end
end
