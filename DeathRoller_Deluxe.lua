local addonName = ...

-- SlashCmdList
SLASH_DEATHROLL1 = "/deathroll"
SLASH_DEATHROLL2 = "/dr"

-- Sub-Commands
HELP = "help"
INFO = "info"

-- Addon Message Prefix
PREFIX = "DEATHROLLDELUXE"

-- DeathRollDialog box
DeathRollDialog = DeathRollDialog or nil

-- Time out variables
local waitingForPong = false
local pongTarget = nil
local pongTimeout = 5 -- seconds
local pongTimer = 0

-- Frame for OnUpdate timer
local timerFrame = CreateFrame("Frame")
timerFrame:Hide()

-- IsPlayerInRange
function IsPlayerInRange()
    return UnitExists("target")
        and UnitIsPlayer("target")
        and CheckInteractDistance("target", 2)
end

function ShowDeathRollDialog(message, title)
    if DeathRollDialog then
        DeathRollDialog.text:SetText(message)
        DeathRollDialog.title:SetText(title or "DeathRoll Deluxe")
        DeathRollDialog:Show()
        return
    end

    local f = CreateFrame("Frame", "DeathRollDialog", UIParent, "UIPanelDialogTemplate")
    f:SetSize(320, 140)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    -- Title text
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("TOP", f, "TOP", 0, -8)
    f.title:SetText(title or "DeathRoll Deluxe")

    -- Message text
    f.text = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.text:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -40)
    f.text:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 36)
    f.text:SetJustifyV("TOP")
    f.text:SetJustifyH("CENTER")
    f.text:SetText(message)

    -- Close button
    local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btn:SetSize(80, 22)
    btn:SetPoint("BOTTOM", f, "BOTTOM", 0, 12)
    btn:SetText("Close")
    btn:SetScript("OnClick", function() f:Hide() end)

    DeathRollDialog = f
end

-- Timer logic for timeout
timerFrame:SetScript("OnUpdate", function(self, elapsed)
    if waitingForPong then
        pongTimer = pongTimer - elapsed
        if pongTimer <= 0 then
            waitingForPong = false
            timerFrame:Hide()
            OnPongTimeout()
        end
    else
        timerFrame:Hide()
    end
end)

function OnPongTimeout()
    ShowDeathRollDialog(
        "No response from " .. (pongTarget or "target") .. " after " .. pongTimeout .. " seconds. Challenge cancelled.",
        "DeathRoll Deluxe")
end

function Pong(sender)
    if waitingForPong and sender == pongTarget then
        waitingForPong = false
        timerFrame:Hide()

        SendAddonMessage(PREFIX, "CHALLENGE", "WHISPER", sender)
    else
        SendAddonMessage(PREFIX, "PONG", "WHISPER", sender)
    end
end

local function ShowMaxWagerWindow(currentMaxCopper, onAccept, onCancel)
    if MaxWagerWindow then MaxWagerWindow:Hide() end

    local f = CreateFrame("Frame", "MaxWagerWindow", UIParent, "UIPanelDialogTemplate")
    f:SetSize(420, 180)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    -- Title
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("TOP", f, "TOP", 0, -8)
    f.title:SetText("Set Maximum Wager")

    -- Yellow prompt
    f.text = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.text:SetPoint("TOP", f, "TOP", 0, -34)
    f.text:SetText("|cffffff00Enter the maximum wager:|r")

    -- Gold input
    f.goldBox = CreateFrame("EditBox", nil, f)
    f.goldBox:SetSize(42, 22)
    f.goldBox:SetFontObject("GameFontHighlight")
    f.goldBox:SetAutoFocus(false)

    f.goldBox:SetNumeric(true)
    f.goldBox:SetMaxLetters(6)
    f.goldBox:SetText(tostring(math.floor((currentMaxCopper or 0) / (100 * 100))))
    f.goldBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    f.goldBox:SetPoint("TOPLEFT", f, "TOPLEFT", 80, -70)
    f.goldBox:SetTextInsets(4, 4, 0, 0)
    f.goldBox:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    f.goldBox:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)

    f.goldIcon = f:CreateTexture(nil, "ARTWORK")
    f.goldIcon:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")
    f.goldIcon:SetSize(20, 20)
    f.goldIcon:SetPoint("LEFT", f.goldBox, "RIGHT", 2, 0)


    -- Silver input
    f.silverBox = CreateFrame("EditBox", nil, f)
    f.silverBox:SetSize(42, 22)
    f.silverBox:SetFontObject("GameFontHighlight")
    f.silverBox:SetAutoFocus(false)

    f.silverBox:SetNumeric(true)
    f.silverBox:SetMaxLetters(2)
    f.silverBox:SetText(tostring(math.floor(((currentMaxCopper or 0) / 100) % 100)))
    f.silverBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    f.silverBox:SetPoint("LEFT", f.goldIcon, "RIGHT", 20, 0)
    f.silverBox:SetTextInsets(4, 4, 0, 0)
    f.silverBox:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    f.silverBox:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)

    f.silverIcon = f:CreateTexture(nil, "ARTWORK")
    f.silverIcon:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")
    f.silverIcon:SetSize(20, 20)
    f.silverIcon:SetPoint("LEFT", f.silverBox, "RIGHT", 2, 0)

    -- Copper input
    f.copperBox = CreateFrame("EditBox", nil, f)
    f.copperBox:SetSize(42, 22)
    f.copperBox:SetFontObject("GameFontHighlight")
    f.copperBox:SetAutoFocus(false)

    f.copperBox:SetNumeric(true)
    f.copperBox:SetMaxLetters(2)
    f.copperBox:SetText(tostring(math.floor((currentMaxCopper or 0) % 100)))
    f.copperBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    f.copperBox:SetPoint("LEFT", f.silverIcon, "RIGHT", 20, 0)
    f.copperBox:SetTextInsets(4, 4, 0, 0)
    f.copperBox:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    f.copperBox:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)

    f.copperIcon = f:CreateTexture(nil, "ARTWORK")
    f.copperIcon:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")
    f.copperIcon:SetSize(20, 20)
    f.copperIcon:SetPoint("LEFT", f.copperBox, "RIGHT", 2, 0)

    -- Show user's balance in gold, silver, copper
    local playerCopper     = GetMoney()
    local playerGold       = math.floor(playerCopper / (100 * 100))
    local playerSilver     = math.floor((playerCopper / 100) % 100)
    local playerCopperOnly = playerCopper % 100
    f.balance              = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.balance:SetPoint("TOP", f.goldBox, "BOTTOM", 80, -10)
    f.balance:SetText(string.format("|cffffff00Your balance: %d gold %d silver %d copper|r", playerGold, playerSilver,
        playerCopperOnly))

    -- Accept and Cancel buttons
    local acceptBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    acceptBtn:SetSize(90, 26)
    acceptBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 28, 22)
    acceptBtn:SetText("Accept")

    local cancelBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    cancelBtn:SetSize(90, 26)
    cancelBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 22)
    cancelBtn:SetText("Cancel")

    -- Accept logic
    acceptBtn:SetScript("OnClick", function()
        local gold = tonumber(f.goldBox:GetText()) or 0
        local silver = tonumber(f.silverBox:GetText()) or 0
        local copper = tonumber(f.copperBox:GetText()) or 0
        gold = math.max(0, gold)
        silver = math.max(0, math.min(99, silver))
        copper = math.max(0, math.min(99, copper))
        local totalCopper = gold * 100 * 100 + silver * 100 + copper
        if totalCopper <= 0 then
            UIErrorsFrame:AddMessage("Amount must be positive!", 1, 0.1, 0.1, 1, 3)
            return
        elseif totalCopper > GetMoney() then
            UIErrorsFrame:AddMessage("You don't have enough money!", 1, 0.1, 0.1, 1, 3)
            return
        end
        if onAccept then onAccept(totalCopper) end
        f:Hide()
    end)

    -- Cancel logic
    cancelBtn:SetScript("OnClick", function()
        if onCancel then onCancel() end
        f:Hide()
    end)

    MaxWagerWindow = f
    f:Show()
end

StaticPopupDialogs["DEATHROLL_CHALLENGE"] = {
    text = "%s has challenged you to DeathRoll!",
    button1 = "Accept",
    button2 = "Decline",
    OnAccept = function(self, data)
        -- Send acceptance, start game, etc.
        print("You accepted the challenge from " .. data.challenger)
        ShowMaxWagerWindow(0, function(wager)
            SendAddonMessage(PREFIX, "ACCEPT", "WHISPER", data.challenger)
        end)
    end,
    OnCancel = function(self, data)
        print("You declined the challenge from " .. data.challenger)
        SendAddonMessage(PREFIX, "DECLINE", "WHISPER", data.challenger)
    end,
    timeout = 30,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function ShowDeathRollChallengeDialog(challenger, onAccept, onDecline)
    StaticPopup_Show("DEATHROLL_CHALLENGE", challenger, nil, {
        challenger = challenger,
        onAccept = onAccept,
        onDecline = onDecline,
    })
end

function Challenge(challenger)
    ShowDeathRollChallengeDialog(challenger)
end

function Decline(sender)
    UIErrorsFrame:AddMessage(sender .. " declined your challenge!", 1, 0.1, 0.1, 1, 3)
    DeathRollDialog:Hide()
end

function Accept(sender)
    ShowMaxWagerWindow(0)
end

function CheckForAddon(target)
    waitingForPong = true
    pongTarget = target
    pongTimer = pongTimeout
    timerFrame:Show()
    SendAddonMessage(PREFIX, "PING", "WHISPER", target)
    -- The actual check happens in Pong/OnPongTimeout, so this function always returns nil
end

function InitChallenge()
    if not IsPlayerInRange() then
        print("target not in range")
        return
    end
    local targetName = UnitName("target")
    ShowDeathRollDialog("Challenging |cff008080" .. targetName .. "|r to Death Roll!")
    CheckForAddon(UnitName("player")) -- TODO: Change this to target once we are out of solo testing
end

function Info()
    print("TODO: implement info function")
end

function Help()
    print("TODO: write help message")
end

local commands = {
    [HELP] = Help,
    [INFO] = Info,
}

local appMessages = {
    ["PING"] = Pong,
    ["CHALLENGE"] = Challenge,
    ["DECLINE"] = Decline,
    ["ACCEPT"] = Accept,
}

function ParseAddonMessages(self, event, ...)
    local msgPrefix, msg, channel, sender = ...
    -- Ignore all AddonMessages not intended for us
    if msgPrefix ~= PREFIX then
        print("ingoring app message for: " .. msgPrefix)
        return
    end

    if appMessages[msg] then
        appMessages[msg](sender)
    end
end

function DeathRoll_SlashCmdHandler(msg, editbox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
    local fn = commands[command] or InitChallenge
    fn(rest)
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", ParseAddonMessages)
SlashCmdList["DEATHROLL"] = DeathRoll_SlashCmdHandler
