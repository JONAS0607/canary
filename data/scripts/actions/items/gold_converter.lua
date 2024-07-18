-- MUDEI PARA TIBIA COINS

local config = {
	[ITEM_GOLD_COIN] = { changeTo = 22118, count = 10 }  -- Converte 10 gold coins para 1 tibia coin
}

local goldConverter = Action()

function goldConverter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local coin = config[target.itemid]
	if not coin then
			return false
	end

	local charges = item:getCharges()
	if coin.changeTo and target.type >= coin.count then
			local convertCount = math.floor(target.type / coin.count)
			local remainingCoins = target.type % coin.count

			target:remove()
			if remainingCoins > 0 then
					player:addItem(target.itemid, remainingCoins)
			end

			for i = 1, convertCount do
					player:addItem(coin.changeTo, 1)
			end

			item:transform(item:getId(), charges - convertCount)
	end

	if item:getCharges() == 0 then
			item:remove()
	end
	return true
end

goldConverter:id(23722, 25719)
goldConverter:register()
