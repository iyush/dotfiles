-- inorder to require luna json we need to manually load get the packer_compiled.lua
dofile(vim.fn.stdpath('config') .. '/plugin/packer_compiled.lua')
local luna = require('lunajson')

local function forAllFiles(directory, func)
	local i, popen = 0, io.popen
	local pfile = popen('ls -a "' .. directory .. '"')
	if (pfile) then
		for filename in pfile:lines() do
			i = i + 1
			if (filename ~= "." and filename ~= "..") then
				func(directory .. "/" .. filename)
			end
		end
		pfile:close()
	end
end

function TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

-- Merges the compile_commands.json from different build directories into
-- one single place
local function mergeCC()
	local wsDirPath = vim.fn.getcwd() .. "/.."

	-- Get all the file paths to compile_commands.json
	local index, ccFilePaths = 1, {}
	forAllFiles(wsDirPath .. "/build", function(fileName)
		forAllFiles(fileName, function(subFileName)
			local ending = "compile_commands.json"
			if subFileName:sub(- #ending) == ending then
				ccFilePaths[index] = subFileName
				index = index + 1
			end
		end)
	end)

	-- Get all the file contents of the compile_commands.json
	local ccFileContents = {}
	for _, ccFile in pairs(ccFilePaths) do
		local fh = io.open(ccFile, "r")
		if (fh) then
			local str = fh:read("*all")
			if string.len(str) ~= 0 then
				print(ccFile)
				local parsed = luna.decode(str)
				for _, _ in ipairs(parsed) do ccFileContents = TableConcat(ccFileContents, parsed)
				end
			end
			fh:close()
		end
	end

	-- output the merged file to src directory
	local outputFilePath = wsDirPath .. "/src/compile_commands.json"
	local fh = io.open(outputFilePath, "w")
	if (fh) then
		fh:write(luna.encode(ccFileContents))
		fh:close()
	end
	print("Written to ", outputFilePath)
end

local isROSWs = false
forAllFiles("..", function(fileName)
	if string.find(fileName, ".catkin_tools") then isROSWs = true end
end)

local output_bufnr = nil;

local function append_data(_, data)
	if data then
		vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
	end
end

local function compile_whole_workspace()
	if (output_bufnr == nil) then
		output_bufnr = vim.api.nvim_create_buf('nobl', 'nomod')

	end
	vim.fn.jobstart("catkin b", {
		stdout_buffered = true,
		on_stdout = append_data,
		on_stderr = append_data,
	})
end

if (isROSWs) then
	print("ROS WS Detected.............")
	vim.api.nvim_create_user_command('ROSMergeCC', function() mergeCC() end, {})
	vim.api.nvim_create_user_command('CompileWS', function() compile_whole_workspace() end, {})
end
