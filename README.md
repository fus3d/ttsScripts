# ttsScripts

A  collection of scripts that I've build for interacting with the Tabletop
Simulator Editor API.  I hope to make these part of a neovim plugin if I ever
get the skills to do so.

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
