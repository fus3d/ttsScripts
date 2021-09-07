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

---- Here docs for script input work.   Will probably move everything to this ----
local script = [[
local notebooks = Notes.getNotebookTabs() 
local bodyText = "" 
local i = "" 
for k,v in pairs(notebooks) do 
  print(v.title)
  i = i .. v.title .. " "
end
print(i)
]]
---

newtab = {}
count = 0
debug = 3

pname = "fail"

newtab["messageID"] = 3
newtab["guid"] = "-1"

print(notebookjson)

newtab["script"] = script

print(type(newtab))
-- print(newtab)
newjson = json.encode(newtab)

print(newjson)
-- test = json.decode(newjson)
-- require 'pl.pretty'.dump(test)
--
client:send(newjson)
client:close()

for x = 42,1,-1
do
-- if it worked print the line out
  server:settimeout(1, t)
  local listen = server:accept()
  local line, err = listen:receive('*a')
  if not err then 
       if debug >= 3 then print(line .. "\n") end
       tab = json.decode(line)
  end
  -- done with client, close the object
end
server:close()
