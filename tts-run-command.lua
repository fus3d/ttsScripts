
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
debug = 1

pname = "fail"

newtab["messageID"] = 3
newtab["guid"] = "-1"

-- local f = assert(io.open("tts-get-notebook.ttslua", "rb"))
-- local script = f:read("*all")

local script = [[
  print(Info.name)
]]

--	if v.name == "Colonist Deck" then
--		local cards = v.getObjects()
--		for x, y in pairs(cards) do
--			print(y.name)
--		end

newtab["script"] = script

if debug >= 3 then print(type(newtab)) end
-- print(newtab)
newjson = json.encode(newtab)

if debug >= 3 then print(newjson) end
-- test = json.decode(newjson)
-- require 'pl.pretty'.dump(test)
--
client:send(newjson)
client:close()

server:settimeout(4)
local listen = server:accept()
local line, err = listen:receive('*a')

-- if it worked print the line out
if not err then 
     if debug >= 3 then print(line .. "\n") end
     tab = json.decode(line)
end
  -- done with client, close the object
listen:close()
