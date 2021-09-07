require "lfs"

-- load namespace
local json = require("cjson")
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 39998))
local client = assert(socket.connect("127.0.0.1", 39999))
local ip, port = server:getsockname()

print("Listening on .. " .. ip ..  ":" .. port)

debug = 0
n = 0
keyset = {} 
dir = 'ttslua/'

filelist = io.popen('ls -1 "'..dir..'"') 
for file in filelist:lines() do
    if debug >= 2 then print(dir..file) end
    os.remove(dir..file)
end

-- Send the message to get tts to send the scripts
client:send("{ \"MessageID\" : 0}\n")
client:close()

-- listen to the response from the server
local listen = server:accept()
-- make sure we don't block waiting for this client's line
listen:settimeout(10)
-- receive the line *a recieves everything that is sent

local line, err = listen:receive('*a')

-- if it worked print the line out
if not err then 
     if debug >= 3 then print(line .. "\n") end
     tab = json.decode(line)
end
  -- done with client, close the object
listen:close()

for k,v in pairs(tab["scriptStates"]) do
    -- print(tab["scriptStates"][k]["name"] .. " -- " .. tab["scriptStates"][k]["guid"] .. "\n")
    filename = (tab["scriptStates"][k]["name"] .. "." .. tab["scriptStates"][k]["guid"])
    print(filename)
    if tab["scriptStates"][k]["script"] then
        file = io.open(dir .. filename .. ".ttslua", "w+")
        if debug >= 1 then print(file) end
        if debug >= 2 then print(tab["scriptStates"][k]["script"]) end
        io.output(file)
        io.write(tab["scriptStates"][k]["script"])
        io.close(file)
    end
    if tab["scriptStates"][k]["ui"] then
        file = io.open(dir .. filename .. ".xml", "w+")
        if debug >= 1 then print(file) end
        if debug >= 2 then print(tab["scriptStates"][k]["ui"]) end
        io.output(file)
        io.write(tab["scriptStates"][k]["ui"])
        io.close(file)
    end
    -- if tableHasKey(tab["scriptStates"][k]["name"],"ui")
    --     file = io.open (filename .. ".xml", "w+")
    --     io.output(file)
    --     io.write(tab["scriptStates"][k]["name"],"ui")
    --     io.close(file)
    -- end
    -- print(tab["scriptStates"][k]["name"] .. " -- " .. tab["scriptStates"][k]["guid"] .. "\n")
    -- n=n+1
    -- keyset[n]=k
end
