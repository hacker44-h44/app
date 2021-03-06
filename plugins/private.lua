local plugin = {}

local function do_keyboard_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = _("Channel"), url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = _("hacker44"), url = 'https://telegram.me/hacker44'},
    		{text = _("mr.pink"), url = 'https://telegram.me/rahbar_salibam},
		},
		{
			{text = _("👥 Groups"), callback_data = 'private:groups'}
		}
	}
	return keyboard
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type ~= 'private' then return end

	if blocks[1] == 'ping' then
		local res = api.sendMessage(msg.from.id, _("Pong!"), true)
		--[[if res then
			api.editMessageText(msg.chat.id, res.result.message_id, 'Response time: '..(os.clock() - clocktime_last_update))
		end]]
	end
	if blocks[1] == 'echo' then
		local res, code = api.sendMessage(msg.chat.id, blocks[2], true)
		if not res then
			api.sendMessage(msg.chat.id, misc.get_sm_error_string(code), true)
		end
	end
	if blocks[1] == 'about' then
		local keyboard = do_keyboard_credits()
		local text = _("This bot is created by [BHH team](https://telegram.me/Bhh_ch) (hacker44 & mr.pink), a multipurpose Lua bot.\n\nThe owner of this bot is @hacker44 & @rahbar_salibam,  use /groups command\n\nBot version: `%s`\n*Some useful links:*"):format(config.human_readable_version .. ' rev.' .. bot.revision)
		api.sendMessage(msg.chat.id, text, true, keyboard)
	end
	if blocks[1] == 'groups' then
		if config.help_groups and next(config.help_groups) then
			local keyboard = {inline_keyboard = {}}
			for group, link in pairs(config.help_groups) do
				if link then
					local line = {{text = group, url = link}}
					table.insert(keyboard.inline_keyboard, line)
				end
			end
			if next(keyboard.inline_keyboard) then
				api.sendMessage(msg.chat.id, _("Select a group:"), true, keyboard)
			end
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'about' then
		local keyboard = do_keyboard_credits()
		local text = _("This bot is created by [BHH team](https://telegram.me/Bhh_ch) (hacker44 & mr.pink), a multipurpose Lua bot.\n\nThe owner of this bot is @hacker44 & @rahbar_salibam,  use /groups command\n\nBot version: `%s`\n*Some useful links:*"):format(config.human_readable_version .. ' rev.' .. bot.revision)
		api.editMessageText(msg.chat.id, msg.message_id, text, true, keyboard)
	end
	if blocks[1] == 'groups' then
		if config.help_groups and next(config.help_groups) then
			local keyboard = {inline_keyboard = {}}
			for group, link in pairs(config.help_groups) do
				if link then
					local line = {{text = group, url = link}}
					table.insert(keyboard.inline_keyboard, line)
				end
			end
			if next(keyboard.inline_keyboard) then
				api.editMessageText(msg.chat.id, msg.message_id, _("Select a group:"), true, keyboard)
			end
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(ping)$',
		config.cmd..'(echo) (.*)$',
		config.cmd..'(about)$',
		config.cmd..'(groups)$',
		'^/start (groups)$'
	},
	onCallbackQuery = {
		'^###cb:fromhelp:(about)$',
		'^###cb:private:(groups)$',
	}
}

return plugin
