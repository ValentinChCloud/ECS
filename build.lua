
-- buildSystem/build.lua
local pp = require("buildSystem.preprocess")

-- Settings for the build system.
local OUTPUT_ZIP = false


-- Add values that all files use. The values in pp.metaEnvironment
-- will be globals in the files we're about to process.
pp.metaEnvironment.DEVELOPER_MODE = true

pp.metaEnvironment.GAME_VERSION_NAME = "v0.0.1 (Bordeaux)"

local excludes = require("excludes")

require('lfs')

function GetFileExtension(url)

local ex = url:match("^.+(%..+)$")
ex = ex:gsub("%.", "")
  return ex
end

function getLuaFilesInDirectory(pathIn, pathOut)
  print("do")
	for files in  lfs.dir(pathIn) do
	repeat
		if files =="." or files == ".." then
		break
		end
		local file = pathIn.."/"..files
		local pathOut = pathOut.."/"..files

		if lfs.attributes(file, "mode") == "directory" then
			getLuaFilesInDirectory(file, pathOut)
		else
			if GetFileExtension(files) == "lua" then
				for i=1,#excludes do
				if excludes[i] == files then
          print("break")
					break
				else
					local info, err = pp.processFile{ pathIn=file, pathOut=pathOut }
				end
				end

			end
		end

	until true
	end

end


function prepro(pathIn, pathOut)
-- Del the repo
	os.execute("rd /s /q "..pathOut)

	os.execute("mkdir "..pathOut)
	-- Copy all directories but not files
	local xco = "xcopy  /t /e \"%cd%\\"..pathIn.."\"".." ".."\"%cd%\\"..pathOut.."\""
	os.execute(xco)
	getLuaFilesInDirectory(pathIn, pathOut)

end




--- MAIN

local pathIn,pathOut = "dev","prod"


prepro(pathIn, pathOut)


--local info, err = pp.processFile{ pathIn="main.lua2p", pathOut="main.lua" }

local love_c = "love.exe prod/"
os.execute(love_c)
