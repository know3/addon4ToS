_G['ADDONS'] = _G['ADDONS'] or {};
_G['ADDONS']['SILVERPOPUP'] = _G['ADDONS']['SILVERPOPUP'] or {};
local g = _G['ADDONS']['SILVERPOPUP'];
local acutil = require('acutil');

g.sil = {};
g.sil.style = '{@st43}{#FFCC66}{nl}';
g.sil.mapTotal = 0;

function SILVERPOPUP_SILVER_UPDATE(actor,evName,itemID,itemQty)
    local itemID = math.floor(itemID);
    if itemID == 900011 then
        FRAME_AUTO_POS_TO_OBJ(g.frame,session.GetMyHandle(),0,0,3,3);
        local frame = g.frame;
        frame:ShowWindow(1);
        local richtxt = frame:GetChild('siltxt');
        g.sil.tempTotal = g.sil.tempTotal + itemQty;
        richtxt:SetText(string.format('%s%d Silver', g.sil.style, g.sil.tempTotal));
        frame:StopUpdateScript("SILVERPOPUP_CLOSE_FUNC");
        frame:RunUpdateScript("SILVERPOPUP_CLOSE_FUNC",  5, 0.0, 0, 5);
    end
end

function SILVERPOPUP_CLOSE_FUNC()
    local frame = g.frame;
    frame:StopUpdateScript("SILVERPOPUP_CLOSE_FUNC");
    frame:ShowWindow(0);
    g.sil.mapTotal = g.sil.mapTotal + g.sil.tempTotal;
    g.sil.tempTotal = 0;
end

function SILVERPOPUP_INIT()
    FRAME_AUTO_POS_TO_OBJ(g.frame,session.GetMyHandle(),0,0,1,3);
    local siltxt = g.frame:GetChild('siltxt');
    siltxt:SetOffset(0,110);

    if (g.sil.mapTotal ~= 0) then
        CHAT_SYSTEM(string.format('%s Silver',acutil.addThousandsSeparator(g.sil.mapTotal)));
    end

    local siltxt = g.frame:GetChild('siltxt');

    siltxt:SetOffset(0,60);
    siltxt:SetGravity(2,2);

    g.sil.tempTotal = 0;
    g.sil.mapTotal = 0;
end

function SILVERPOPUP_ON_INIT(addon,frame)
    g.addon = addon;
    g.frame = frame;

    addon:RegisterMsg('ITEM_PICK', 'SILVERPOPUP_SILVER_UPDATE');
    addon:RegisterMsg('GAME_START_3SEC','SILVERPOPUP_INIT');
end