local PATTERNS = {
    -- X://Y most urls
    "^(%a[%w+.-]+://%S+)",
    "%f[%S](%a[%w+.-]+://%S+)",
    -- www.X.Y domain
    "^(www%.[-%w_%%]+%.(%a%a+))",
    "%f[%S](www%.[-%w_%%]+%.(%a%a+))",
    -- www.X.Y domain and path
    "^(www%.[-%w_%%]+%.(%a%a+)/%S+)",
    "%f[%S](www%.[-%w_%%]+%.(%a%a+)/%S+)",
    -- ip address
    "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d)%f[%D]",
    "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d)%f[%D]",
    -- ip address with port
    "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]",
    "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]",
    -- ip address with path
    "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)",
    "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)",
    -- ip address with port and path
    "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)",
    "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)",
}

local function formatURL(url)
    url = "|cff".."18f24b".."|Hurl:"..url.."|h"..url.."|h|r ";
    return url;
end


local function makeClickable(self, event, msg, ...)    
    for k,p in pairs(PATTERNS) do
        if string.find(msg, p) then
            msg = string.gsub(msg, p, formatURL("%1"))
            return false, msg, ...
        end
    end
    
    return false, msg, ...
end

StaticPopupDialogs["Click_URL_Clicker"] = {
    text = "CTRL + C to copy the link !",
    button1 = "Close",
    OnAccept = function()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3, 
    OnShow = 
        function (self, data)
            self.editBox:SetText(data.url)
            self.editBox:HighlightText()
        end,
    hasEditBox = true
}

local ChatFrame_OnHyperlinkShow_orig = ChatFrame_OnHyperlinkShow;
local function URLClicker_ChatFrame_OnHyperlinkShow(frame, link, text, button)
    if (string.sub(link, 1, 3) == "url") then
        local url = string.sub(link, 5);
        local d = {}
        d.url = url
        StaticPopup_Show("Click_URL_Clicker", "", "", d)
    else
        ChatFrame_OnHyperlinkShow_orig(frame, link, text, button);
    end
end
ChatFrame_OnHyperlinkShow = URLClicker_ChatFrame_OnHyperlinkShow;

local CHAT_TYPES = {
    "AFK",
    "BATTLEGROUND_LEADER",
    "BATTLEGROUND",
    "BN_WHISPER",
    "BN_WHISPER_INFORM",
    "CHANNEL",
    "COMMUNITIES_CHANNEL",
    "DND",
    "EMOTE",
    "GUILD",
    "OFFICER",
    "PARTY_LEADER",
    "PARTY",
    "RAID_LEADER",
    "RAID_WARNING",
    "RAID",
    "SAY",
    "WHISPER",
    "WHISPER_INFORM",
    "YELL",
    "SYSTEM"
}

for _, chatType in pairs(CHAT_TYPES) do
    ChatFrame_AddMessageEventFilter("CHAT_MSG_" .. chatType, makeClickable)
end
