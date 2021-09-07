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

function rtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
end

newtab = {}
count = 0
dir = 'notebook/'
debug = 3

pname = "fail"

newtab["messageID"] = 3
newtab["guid"] = "-1"

local script = [[
local notebooks = Notes.getNotebookTabs() 
local bodyText = "" 
local i = "" 
for k,v in pairs(notebooks) do 
  if v.title == "Setup" then 
    i = v.index 
  end 
end

Notes.editNotebookTab({index = i, body = notebook})
print("Setup notebook successfully uploaded")
]]

-- Add in the json from the notebook file here

local jsonf = assert(io.open(dir .. "setup.notebook", "rb"))
local notebookjson = jsonf:read("*all") 

notebookjson = rtrim(notebookjson)

print(notebookjson)

local editedjson = "local notebook = \'"  ..  notebookjson .. "\'"

newtab["script"] = editedjson .. script

print(type(newtab))
-- print(newtab)
newjson = json.encode(newtab)

print(newjson)
-- test = json.decode(newjson)
-- require 'pl.pretty'.dump(test)
--
client:send(newjson)
client:close()

server:settimeout(2)
local listen = server:accept()
local line, err = listen:receive('*a')

-- if it worked print the line out
if not err then 
     if debug >= 3 then print(line .. "\n") end
     tab = json.decode(line)
end
  -- done with client, close the object
server:close()
