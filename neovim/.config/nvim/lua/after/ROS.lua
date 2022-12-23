
-- inorder to require luna json we need to manually load get the packer_compiled.lua
dofile(vim.fn.stdpath('config') .. '/plugin/packer_compiled.lua')
luna = require('lunajson')

function forAllFiles(directory, func)
    local i, popen = 0, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
				if (filename ~= "." and filename ~= "..") then
					func(directory .. "/" .. filename)
				end
    end
    pfile:close()
    return t
end
function TableConcat(t1,t2)
   for i=1,#t2 do
      t1[#t1+1] = t2[i]
   end
   return t1
end

-- Merges the compile_commands.json from different build directories into
-- one single place
function mergeCC() 
	local wsDirPath = vim.fn.getcwd() .. "/.."
	
	-- Get all the file paths to compile_commands.json
	local index, ccFilePaths= 1, {}
	forAllFiles(wsDirPath .. "/build", function(fileName)
		forAllFiles(fileName, function(subFileName)
			local ending = "compile_commands.json"
			if subFileName:sub(-#ending) == ending then
				ccFilePaths[index] = subFileName
				index = index + 1
			end
		end)
	end)

	-- Get all the file contents of the compile_commands.json
	ccFileContents = {}
	for k, ccFile in pairs(ccFilePaths) do
		local fh = io.open(ccFile, "r")
		local str = fh:read("*all")
		if string.len(str) ~= 0 then
			print(ccFile)
			local parsed = luna.decode(str)
			for _,v in ipairs(parsed) do
				ccFileContents = TableConcat(ccFileContents, parsed)
			end
		end
		fh.close()
	end

	-- output the merged file to src directory
	local outputFilePath = wsDirPath .. "/src/compile_commands.json"
	local fh = io.open(outputFilePath, "w")
	fh:write(luna.encode(ccFileContents))
	fh.close()
	print("Written to ", outputFilePath)
end

isROSWs = false
forAllFiles("..", function(fileName) 
	if string.find(fileName,".catkin_tools") then isROSWs = true end
end)


if (isROSWs) then
	print("ROS WS Detected.............")
	vim.api.nvim_create_user_command('ROSMergeCC', function() mergeCC() end, {})
end
