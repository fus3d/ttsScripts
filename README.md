# ttsScripts
Scripts to interact with Tabletop Simulator via the editor API. 

Ideally these will be made into a neovim plugin at some point.

Documentation on the TTS Editor API can be found at: https://api.tabletopsimulator.com/externaleditorapi/

Functions implemented in these scripts

get scripts and xml files via message ID 0
save scripts and xml files via message ID 1
get / put notebooks using lua script message ID 3
run sample / test code using lua script message ID 3

Be careful with directories, 'get' scripts will overwrite files without warning and could lose work. This will be fixed in the future.

Files included:

    tts-get-scripts.lua     - Download scripts and store them in a directory
    tts-get-notebook.lua    - Download a single notebook and store it
    tts-list-notebooks.lua  - List the notebooks available (most settings are
                              stored in notebooks that only the black user can
                              view)]
    tts-put-notebook.lua    - Upload a single notebook
    tts-put-scripts.lua     - Upload all of the scripts in the specified directory
    tts-query-scripts.lua   - Query the scripts but don't save them.   Send to STDOUT
    tts-run-command.lua     - script to run any command adhoc.   Replace the "script"
                              here doc with whatever lua you want TTS to run
