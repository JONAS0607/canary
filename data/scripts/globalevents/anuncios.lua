local messages = {
	{
		message = "Agora todos podem transformar 10 Gold Coins em 1 Tibia Coin! Adquira o item Gold Converter no site para aproveitar.",
		interval = 3600, -- 1 hora
		title = "Converter Gold para Tibia Coin",
		color = WEBHOOK_COLOR_EVENT
	},
	{
		message = "Solicite seu saque no site na aba SAQUES, troque suas TC farmadas no jogo por dinheiro real! Aproveite!",
		interval = 1800, -- 1 hora
		title = "Saque de dinheiro real no Site!",
		color = WEBHOOK_COLOR_EVENT
	},
	{
		message = "Lembre-se de participar dos eventos semanais como Double EXP, Tibia Coins entre outros!",
		interval = 7200, -- 2 horas
		title = "Double EXP todos os finais de semana!",
		color = WEBHOOK_COLOR_EVENT
	},
	{
		message = "Diga !reward e ganhe uma Exercice Weapon de sua escolha!",
		interval = 10800, -- 3 horas
		title = "Bonus Exercise Weapon",
		color = WEBHOOK_COLOR_EVENT
	}
}

local function sendMessage(index)
	local msgData = messages[index]
	local message = msgData.message
	Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	logger.info(message)

	local webhookMessage = {
		embeds = {
			{
				title = msgData.title,
				description = message,
				color = msgData.color,
				footer = {
					text = "TesteServidorOTS | " .. os.date("%d/%m/%Y %H:%M:%S")
				}
			}
		}
	}

	Webhook.sendMessage(msgData.title, webhookMessage)
end

local function registerMessages()
	for index, msgData in ipairs(messages) do
		local event = GlobalEvent("MessageEvent" .. index)

		function event.onTime(interval)
			sendMessage(index)
			return true
		end

		event:interval(msgData.interval * 1000)
		event:register()
	end
end

registerMessages()
