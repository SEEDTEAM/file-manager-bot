# File manager telegram bot

A linux file manager telegram bot

# commands

 **cd [folder]**

`/cd /test/test`

 **ls**

`/ls`

  **mkdir [folder name]**

`/mkdir new folder`

 **rmdir [folder name]**

`/rmdir new folder`

 **rm [file name]**

`/rm test.mp3`

 **touch [file name]**

`/touch test.txt`

 **cat [file name]**

`/cat test.txt`

 **tofile [file name] [text]**

_Will create a file with name [file name] and will put [text] in it_

`/tofile test.py print "Hello world !"`

 **shell [command]**

`/shell uptime`

 **cp [file] [dir]**

`/cp test.png test/test`

 **mv [file] [dir]**

`/mv test.png test/test`

 **upload [file name]**

`/upload test.txt`

`Will upload that file in current folder`

 **download <file name>**

_will download that file you replied to_

 `/download`

Bot will select a name automatically

`/download [file name]`

Bot will save file with [file name]

_Bot can upload files up to 50 mg and download files up to 20 mg_

# Installation

You should have [lua](http://www.lua.org/) installed

```bash
sudo apt-get install lua

```
Clone the bot

```
git clone https://github.com/Imandaneshi/file-manager-bot.git
cd file-manager-bot

```

Then install bot using

`bash launch.sh install`


Then enter your base folder and telegram bot api key in bot.lua (config part)

```lua

local bot_api_key = ""
local BASE_URL = "https://api.telegram.org/bot"..bot_api_key
-- Base folder like
-- local BASE_FOLDER = "/home/imandaneshi/files/"
local BASE_FOLDER = ""

```
Save bot.lua

Start the bot

`bash launch.sh`
