
local ShopComunication = GlobalEvent("ShopComunication")

function ShopComunication.onThink(interval, lastExecution)
  local queryShop = db.storeQuery('SELECT * FROM `z_ots_comunication`')
  if queryShop ~= false then
      repeat
          local id, player = result.getNumber(queryShop, 'id'), Player(result.getString(queryShop, 'name'))
          if player then
              local item_id, item_count = result.getNumber(queryShop, 'param1'), result.getNumber(queryShop, 'param2')
              local container_id, container_count = result.getNumber(queryShop, 'param3'), result.getNumber(queryShop, 'param4')
              local offer_type = result.getString(queryShop, 'param5')
              local item_name = result.getString(queryShop, 'param6')

              -- ITEMS
              if offer_type == 'item' then
                if item_id == 23722 or item_id == 28525 then
                    local item = Game.createItem(item_id, 1)
                    item:setAttribute(ITEM_ATTRIBUTE_CHARGES, 500)
                    player:addItemEx(item, false, INDEX_WHEREEVER, FLAG_NOLIMIT)
                else
                    player:addItem(item_id, item_count, INDEX_WHEREEVER, FLAG_NOLIMIT)
                end
                player:sendTextMessage(MESSAGE_TRADE, 'Voce recebeu >> ' .. item_name .. ' << do Edge OT Shop em seu depot.')

              -- CONTAINER
              elseif offer_type == 'container' then
                  local container_id, container_count = result.getNumber(queryShop, 'param3'), result.getNumber(queryShop, 'param4')
                  local i, new_container = 0, player:addItem(container_id, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
                  while i ~= container_count do
                      new_container:addItem(item_id, item_count, INDEX_WHEREEVER, FLAG_NOLIMIT)
                      i = i + 1
                  end

                  player:sendTextMessage(MESSAGE_TRADE, 'Voce recebeu >> '.. item_name ..' << do OT Shop em seu depot.')

              -- ADDON
              elseif offer_type == 'addon' then
                  player:addOutfitAddon(item_id, 3)
                  player:addOutfitAddon(item_count, 3)
                  player:sendTextMessage(MESSAGE_TRADE, 'Voce recebeu >> '.. item_name ..'.')

              -- MOUNT
              elseif offer_type == 'mount' then
                  player:addMount(item_id)
                  player:sendTextMessage(MESSAGE_TRADE, 'Voce recebeu >> '.. item_name ..'.')
            
                  player:sendTextMessage(MESSAGE_TRADE, 'Voce recebeu >> '.. item_name ..'.')
              elseif offer_type == 'pacc' then
                  player:addPremiumDays(30)
                  player:sendTextMessage(MESSAGE_TRADE, 'Voce recebeu >> '.. item_name ..'.')
              end

              db.asyncQuery('DELETE FROM `z_ots_comunication` WHERE `id` = ' .. id)
              db.asyncQuery('UPDATE `z_shop_history` SET `trans_state` = \'realized\', `trans_real` = ' .. os.time() .. ' WHERE id = ' .. id)
          end

      until not result.next(queryShop)
      result.free(queryShop)
  end

  return true
end


ShopComunication:interval(10000)
ShopComunication:register()