package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'
URL = require('socket.url')
JSON = require('dkjson')
HTTPS = require('ssl.https')
----config----
local bot_api_key = ""
local BASE_URL = "https://api.telegram.org/bot"..bot_api_key
-- Base folder like
-- local BASE_FOLDER = "/home/imandaneshi/files/"
local BASE_FOLDER = ""
-------

----utilites----

function is_admin(msg)-- Check if user is admin or not
  local var = false
  local admins = {123456789,987654321}-- put your id here
  for k,v in pairs(admins) do
    if msg.from.id == v then
      var = true
    end
  end
  return var
end

function sendRequest(url)
  local dat, res = HTTPS.request(url)
  local tab = JSON.decode(dat)

  if res ~= 200 then
    return false, res
  end

  if not tab.ok then
    return false, tab.description
  end

  return tab

end

function getMe()--https://core.telegram.org/bots/api#getfile
    local url = BASE_URL .. '/getMe'
  return sendRequest(url)
end

function getUpdates(offset)--https://core.telegram.org/bots/api#getupdates

  local url = BASE_URL .. '/getUpdates?timeout=20'

  if offset then

    url = url .. '&offset=' .. offset

  end

  return sendRequest(url)

end

function sendMessage(chat_id, text, disable_web_page_preview, reply_to_message_id, use_markdown)--https://core.telegram.org/bots/api#sendmessage

	local url = BASE_URL .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)

	if disable_web_page_preview == true then
		url = url .. '&disable_web_page_preview=true'
	end

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

	if use_markdown then
		url = url .. '&parse_mode=Markdown'
	end

	return sendRequest(url)

end
function sendDocument(chat_id, document, reply_to_message_id)--https://github.com/topkecleon/otouto/blob/master/bindings.lua

	local url = BASE_URL .. '/sendDocument'

	local curl_command = 'cd \''..BASE_FOLDER..currect_folder..'\' && curl -s "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "document=@' .. document .. '"'

	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end
	io.popen(curl_command):read("*all")
	return

end
function download_to_file(url, file_name, file_path)--https://github.com/yagop/telegram-bot/blob/master/bot/utils.lua
  print("url to download: "..url)

  local respbody = {}
  local options = {
    url = url,
    sink = ltn12.sink.table(respbody),
    redirect = true
  }
  -- nil, code, headers, status
  local response = nil
    options.redirect = false
    response = {HTTPS.request(options)}
  local code = response[2]
  local headers = response[3]
  local status = response[4]
  if code ~= 200 then return nil end
  local file_path = BASE_FOLDER..currect_folder..file_name

  print("Saved to: "..file_path)

  file = io.open(file_path, "w+")
  file:write(table.concat(respbody))
  file:close()
  return file_path
end
--------

function bot_run()
	bot = nil

	while not bot do -- Get bot info
		bot = getMe()
	end

	bot = bot.result

	local bot_info = "Username = @"..bot.username.."\nName = "..bot.first_name.."\nId = "..bot.id.." \n"

	print(bot_info)

	last_update = last_update or 0

	is_running = true

	currect_folder = ""
end

function msg_processor(msg)
	if msg == nil then return end
	if not is_admin(msg) then return end-- Admins only !
	if msg.date < os.time() - 5 then -- Ignore old msgs
		return
	end
	if msg.text then
		if msg.text:match("^/ls$") then
			local action = io.popen('ls "'..BASE_FOLDER..currect_folder..'"'):read("*all")
      sendMessage(msg.chat.id, action)
    end
    if msg.text:match("^/cd (.*)$") then
			local matches = { string.match(msg.text, "^/cd (.*)$") }
			currect_folder = matches[1]
			sendMessage(msg.chat.id, "Currect folder = "..BASE_FOLDER..currect_folder)
    end
    if msg.text:match("^/mkdir (.*)$") then
      local matches = { string.match(msg.text, "^/mkdir (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && mkdir \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, "Created folder ")
    end
		if msg.text:match("^/rm (.*)$") then
			local matches = { string.match(msg.text, "^/rm (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && rm -f \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, "Deleted "..matches[1])
		end
		if msg.text:match("^/cat (.*)$") then
			local matches = { string.match(msg.text, "^/cat (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && cat \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, action)
		end
		if msg.text:match("^/rmdir (.*)$") then
			local matches = { string.match(msg.text, "^/rmdir (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && rmdir \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, "Deleted "..matches[1])
		end
		if msg.text:match("^/touch (.*)$") then
			local matches = { string.match(msg.text, "^/touch (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && touch \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, "Created  file "..matches[1])
		end
		if msg.text:match("^/tofile ([^%s]+) (.*)$") then
			local matches = { string.match(msg.text, "^/tofile ([^%s]+) (.*)$") }
			local file = io.open(BASE_FOLDER..currect_folder..matches[1], "w")
			file:write(matches[2])
			file:flush()
			file:close()
			sendMessage(msg.chat.id, "Done !")
		end
		if msg.text:match("^/shell (.*)$") then
			local matches = { string.match(msg.text, "^/shell (.*)$") }
			local text = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && '..matches[1]:gsub('—', '--')):read('*all')
			sendMessage(msg.chat.id, text)
		end
		if msg.text:match("^/cp (.*) (.*)$") then
			local matches = { string.match(msg.text, "^/cp (.*) (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && cp -r \''..matches[1]..'\' \''..matches[2]..'\''):read("*all")
			sendMessage(msg.chat.id, "Copied file "..matches[1])
		end
		if msg.text:match("^/mv (.*) (.*)$") then
			local matches = { string.match(msg.text, "^/mv (.*) (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && mv \''..matches[1]..'\' \''..matches[2]..'\''):read("*all")
			sendMessage(msg.chat.id, "Moved file "..matches[1])
		end
		if msg.text:match("^/upload (.*)$") then
			local matches = { string.match(msg.text, "^/upload (.*)$") }
			if io.popen('find '..BASE_FOLDER..currect_folder..matches[1]):read("*all") == '' then
				sendMessage(msg.chat.id, "File does not exist")
			else
				sendMessage(msg.chat.id, "Uploading file "..matches[1])
				sendDocument(msg.chat.id, matches[1])
			end
		end
		if msg.text:match("^/download (.*)$") or msg.text:match("^/download$") then--Turn your bot privacy off or it won't  work on chats(groups and supergroups)
			if not msg.reply_to_message then
				sendMessage(msg.chat.id, "Reply to something !")
				return
			end
			local file = ""
			local filename = ""
			if msg.reply_to_message.photo then
				file = msg.reply_to_message.photo[1].file_id
				filename = "somepic.jpg"
			elseif msg.reply_to_message.video then
				file = msg.reply_to_message.video.file_id
				filename = "somevideo.mp4"
				if msg.reply_to_message.video.file_size > 19000000 then
					return
				end
			elseif msg.reply_to_message.document then
				file = msg.reply_to_message.document.file_id
				filename = msg.reply_to_message.document.file_name
				if msg.reply_to_message.document.file_size > 19000000 then
					return
				end
			elseif msg.reply_to_message.audio then
				filename = msg.reply_to_message.audio.title..".mp3"
				file = msg.reply_to_message.audio.file_id
			elseif msg.reply_to_message.sticker then
				filename = "somevoice.png"
				file = msg.reply_to_message.sticker.file_id
			elseif msg.reply_to_message.voice then
				filename = "somevoice.ogg"
				file = msg.reply_to_message.voice.file_id
			else
				return
			end
			local url = BASE_URL .. '/getFile?file_id='..file
			local res = HTTPS.request(url)
			local jres = JSON.decode(res)
			if string.match(msg.text, "^/download (.*)$") then
				local matches = { string.match(msg.text, "^/download (.*)$") }
				filename = matches[1]
			end

			local download = download_to_file("https://api.telegram.org/file/bot"..bot_api_key.."/"..jres.result.file_path, filename)
			sendMessage(msg.chat.id, "file downloaded")
		end
	end
	return
end
bot_run() -- Run main function
while is_running do -- Start a loop witch receive messages.
	local response = getUpdates(last_update+1) -- Get the latest updates using getUpdates method
	if response then
		for i,v in ipairs(response.result) do
			last_update = v.update_id
			msg_processor(v.message)
		end
	else
		print("Conection failed")
	end

end
print("Bot halted")
