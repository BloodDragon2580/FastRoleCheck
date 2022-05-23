local function AcceptRole(accept)
   if ( FastRoleCheck.Settings.Enabled ) then
      accept();
   elseif ( FastRoleCheck.Settings.DisableOnce ) then
      FastRoleCheck.Settings.DisableOnce = false;
      FastRoleCheck.Settings.Enabled = true;
   end
end

local function LFRAcceptRole(self)
   AcceptRole(function()
       LFGListApplicationDialog.SignUpButton:Click();
   end);
end

local function LFDAcceptRole(self)
   AcceptRole(function()
       LFDRoleCheckPopupAcceptButton:Click();
   end);
end

local function LFGAcceptRole(self)
   AcceptRole(function()
       LFGInvitePopupAcceptButton:Click();
   end);
end

LFGListApplicationDialog:SetScript("OnShow", LFRAcceptRole);
LFDRoleCheckPopup:SetScript("OnShow", LFDAcceptRole);
LFGInvitePopup:SetScript("OnShow", LFGAcceptRole);
