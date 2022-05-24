local myName, me = ...
local L = me.L

FastRoleCheck = {};

FastRoleCheck.Defaults = {
   Enabled = true,
   DisableOnce = false,
   Comment = ""
};

SLASH_FastRoleCheck1 = "/FastRoleCheck";

local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("PLAYER_FLAGS_CHANGED");

function FastRoleCheck.ShowMessage(text)
   print("|cffd6266cFastRoleCheck:|r " .. text);
end

function SlashCmdList.FastRoleCheck(msg, editbox)
   local command, rest = msg:match("^(%S*)%s*(.-)$");
   command = command:lower();

   if ( command == "enable" ) then
      FastRoleCheck.PrevStatus = nil;
      FastRoleCheck.Settings.DisableOnce = false;
      FastRoleCheck.Settings.Enabled = true;
      FastRoleCheck.ShowMessage(L["en"]);
   elseif ( command == "disable" ) then
      FastRoleCheck.PrevStatus = nil;
      FastRoleCheck.DisableOnce = false;
      FastRoleCheck.Settings.Enabled = false;
      FastRoleCheck.ShowMessage(L["dis"]);
   elseif ( command == "disableonce" ) then
      FastRoleCheck.PrevStatus = nil;
      FastRoleCheck.Settings.DisableOnce = true;
      FastRoleCheck.Settings.Enabled = false;
      FastRoleCheck.ShowMessage(L["disonce"]);
   else
      FastRoleCheck.ShowMessage(L["commands:"]);
      print(L["enable"]);
      print(L["disable"]);
      print(L["disableonce"]);
   end
end

local function RestorePrevStatus()
   FastRoleCheck.Settings.Enabled = FastRoleCheck.PrevStatus;
   FastRoleCheck.PrevStatus = nil;
end

local function EventHandler(self, event, arg, ...)
   if ( event == "ADDON_LOADED" and arg == "FastRoleCheck" ) then
      FastRoleCheck.ShowMessage(L["settings"]);

      FastRoleCheck.Settings = FastRoleCheck.Defaults;
      if ( FastRoleCheck_Settings ) then
         for k, v in pairs(FastRoleCheck_Settings) do
            FastRoleCheck.Settings[k] = v;
         end
      end
   elseif ( event == "PLAYER_FLAGS_CHANGED" and arg == "player" ) then
      local isAFK, isDND = UnitIsAFK(arg), UnitIsDND(arg);
      if ( isAFK or isDND ) then
         if ( not FastRoleCheck.PrevStatus ) then
            FastRoleCheck.PrevStatus = FastRoleCheck.Settings.Enabled;
         end
         FastRoleCheck.Settings.Enabled = false;
      elseif ( FastRoleCheck.PrevStatus ~= nil ) then
         RestorePrevStatus();
      end
   elseif ( event == "PLAYER_LOGOUT" ) then
      if ( FastRoleCheck.PrevStatus ~= nil ) then
         RestorePrevStatus();
      end
      FastRoleCheck_Settings = FastRoleCheck.Settings;
   end
end

frame:SetScript("OnEvent", EventHandler);
