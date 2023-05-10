local function IsAuctionableItem(itemLink)
  local bindType = select(14, GetItemInfo(itemLink))
  return bindType ~= LE_ITEM_BIND_ON_ACQUIRE and bindType ~= LE_ITEM_BIND_QUEST
end

hooksecurefunc(Auctionator.Tooltip, "ShowTipWithPricingDBKey",
  function(tooltipFrame, dbKeys, itemLink, itemCount)
    if #dbKeys == 0 or itemLink == nil or not IsAuctionableItem(itemLink) then
      return
    end

    local showStackPrices = IsShiftKeyDown();

    if not Auctionator.Config.Get(Auctionator.Config.Options.SHIFT_STACK_TOOLTIPS) then
      showStackPrices = not IsShiftKeyDown();
    end

    local countString = ""
    if itemCount and showStackPrices then
      countString = Auctionator.Utilities.CreateCountString(itemCount)
    else
      itemCount = 1
    end

    local history = Auctionator.Database:GetPriceHistory(dbKeys[1])
    local total = 0
    for _, entry in ipairs(history) do
      total = total + entry.minSeen
    end
    local auctionPrice = math.floor(total / #history * itemCount)

    if auctionPrice ~= 0 then
      tooltipFrame:AddDoubleLine(
        "Auction Mean" .. countString,
        WHITE_FONT_COLOR:WrapTextInColorCode(
          Auctionator.Utilities.CreatePaddedMoneyString(auctionPrice)
        )
      )
    else
      tooltipFrame:AddDoubleLine(
        "Auction Mean" .. countString,
        WHITE_FONT_COLOR:WrapTextInColorCode(
          AUCTIONATOR_L_UNKNOWN .. "  "
        )
      )
    end
  end
)
