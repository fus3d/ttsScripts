-- Lua Tabletop Simulator Put Script.   This will upload all the scripts from the configured directory to TTS
-- using the "save and load" procedure (messageID: 1)
--
-- TODO
-- Configuration File directory, server, ports, etc
-- error checking

require "lfs"

-- load namespace
local json = require("cjson")
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 39998))
local client = assert(socket.connect("127.0.0.1", 39999))
local ip, port = server:getsockname()

newtab = {}
count = 0
dir = 'ttslua/'
debug = 3

--- function to split the file names on .
function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

filelist = io.popen('ls -1 "'..dir..'"') 

-- print(type(dirlist))
-- print(dirlist)
-- for n in dirlist do table.insert(a, n) end
-- table.sort(dirlist)
-- require 'pl.pretty'.dump(dirlist)Y

pname = "fail"

newtab["messageID"] = 1
newtab["scriptStates"] = {}

for file in filelist:lines() do                         --Loop through all files
    print(file)
    if not ((file == ".") or (file == "..")) then       --just make sure we didn't get the dirs, current method won't
        filesplit = mysplit(file, ".")
        name = filesplit[1]
        guid = filesplit[2]
        flabel = filesplit[3]
        if flabel == "ttslua" then 
            ftype = "script"
            print("script")
        elseif flabel == "xml" then
            ftype = "ui"
            print("ui")
        else 
            error("No label detected", 2)
        end

        local f = assert(io.open(dir .. file, "rb"))
        local text = f:read("*all")
        -- local text = rtext:gsub("%s%s%s%s", "\t")
        if(text == nil) then error("no text to work on", 2) end

            -- A Lua table is considered to be an array if and only if its set of keys is a
            -- consecutive sequence of positive integers starting at 1. Arrays are encoded like
            --- so: `[2, 3, false, "hi"]`. Any other type of Lua table is encoded as a json
            --- object, encoded like so: `{"key1": 2, "key2": false}`.
            -- print("Test4 - ", pname, name)
        if not (pname == name) then
            count = count + 1
            newtab["scriptStates"][count] = {}
            newtab["scriptStates"][count]["name"] = name
            newtab["scriptStates"][count]["guid"] = guid
                -- print(test)
        end
        newtab["scriptStates"][count][ftype] = text
        -- require 'pl.pretty'.dump(newtab)
        --
        -- preptext = "{ "scriptStates": [ {"
        -- filetable 

        -- name, guid, script = split(file, ".")
        -- newtab["scriptStates"][A
        pname = name
        -- end
    end
end
print(type(newtab))
print(newtab)
newjson = json.encode(newtab)

print(newjson)
-- test = json.decode(newjson)
-- require 'pl.pretty'.dump(test)
--
client:send(newjson)
client:close()

local listen = server:accept()
listen:settimeout(10)
local line, err = listen:receive('*a')

-- if it worked print the line out
if not err then 
     if debug >= 3 then print(line .. "\n") end
     tab = json.decode(line)
end
  -- done with client, close the object
listen:close()
