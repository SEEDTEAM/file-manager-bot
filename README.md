# File manager telegram bot

A linux file manager telegram bot

# commands

 **cd [folder]**

_Open folder_

`/cd /test/test`

 **ls**

_List folders_

`/ls`

  **mkdir [folder name]**

_Create a folder with name chosen_

`/mkdir new folder`

 **rmdir [folder name]**

_Remove the folder chosen_

`/rmdir new folder`

 **rm [file name]**

_Remove file_

`/rm test.mp3`

 **touch [file name]**

_Create a file with name chosen_

`/touch test.txt`

 **cat [file name]**

_Print the content_

`/cat test.txt`

 **tofile [file name] [text]**

_Will create a file with name [file name] and will put [text] in it_

`/tofile test.py print "Hello world !"`

 **shell [command]**
 
 _Allow use the [command] on terminal_

`/shell uptime`

 **cp [file] [dir]**

_Copie [file] to folder [dir]_

`/cp test.png test/test`

 **mv [file] [dir]**

_Move [file] to folder [dir]_

`/mv test.png test/test`

 **upload [file name]**

_Will upload that file in current folder_

`/upload test.txt`

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
sudo apt-get install lua5.1

```
Clone the bot

```
git clone https://github.com/SEEDTEAM/file-manager-bot.git
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

And enter your telegram-id in admins table in [bot.lua](https://github.com/SEEDTEAM/file-manager-bot/blob/master/bot.lua#L19)
```lua
local var = false
  local admins = {123456789,987654321}-- put your id here
  for k,v in pairs(admins) do

```

Save bot.lua

Start the bot

`bash launch.sh`
