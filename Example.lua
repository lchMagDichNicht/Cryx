loadstring(game:HttpGet("https://raw.githubusercontent.com/lchMagDichNicht/Cryx/refs/heads/main/AutoTheme.lua"))()
wait(0.2)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()


local Window = Library:CreateWindow({
    Title = 'Cryx',
    Icon = 88682207577999,
    ShowCustomCursor = false,
    DisableSearch = true,
    Size = UDim2.fromOffset(650, 500),
    IconSize = UDim2.fromOffset(65, 65),
    Footer = ' ',
    NotifySide = "Right",
    Resizable = false,
})

local Tabs = {
    Info = Window:AddTab("Info", "info"),
	Main = Window:AddTab("Main", "globe"),
	Settings = Window:AddTab("UI Settings", "settings"),
}


local InfoGroup = Tabs.Info:AddLeftGroupbox("Key Info","key")
local InfoGroupRight = Tabs.Info:AddRightGroupbox("Home","house")

-- Player Info
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local imageUrl = Players:GetUserThumbnailAsync(
    player.UserId,
    Enum.ThumbnailType.HeadShot,
    Enum.ThumbnailSize.Size420x420
)

InfoGroupRight:AddImage("MyImage", {
    Image = imageUrl,
    Height = 200,
})

InfoGroupRight:AddLabel("Good afternoon "..player.DisplayName, false)
InfoGroupRight:AddLabel("Welcome back to Cryx!", true)

-- 🔐 FALLBACKS (WICHTIG)
KEY = KEY or "NO KEY"
data = data or {}

-- 🔑 shorten key
local shortKey = KEY
if type(KEY) == "string" and #KEY > 12 then
    shortKey = string.sub(KEY, 1, 10) .. "#####"
end

-- 📦 type & expire (safe)
local keyType = data.type or "No Key"
local expiresAt = data.expiresAt

-- 🏷️ LABELS
local KeyLabel = InfoGroup:AddLabel("Key: " .. shortKey, false)
local TypeLabel = InfoGroup:AddLabel("Type: " .. keyType, false)
local TimeLabel = InfoGroup:AddLabel("Expires: Loading...", false)

-- ⏳ format function
local function formatTime(seconds)
    local d = math.floor(seconds / 86400)
    local h = math.floor((seconds % 86400) / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60

    if d > 0 then
        return string.format("%dd %02dh %02dm", d, h, m)
    else
        return string.format("%dh %02dm %02ds", h, m, s)
    end
end

-- 🔥 LOGIC (SAFE)
if keyType == "lifetime" then
    TimeLabel:SetText("Expires: Never")

elseif not expiresAt then
    TimeLabel:SetText("Expires: No Data")

else
    task.spawn(function()
        while true do
            local now = DateTime.now().UnixTimestampMillis
            local left = math.floor((expiresAt - now) / 1000)

            if left <= 0 then
                TimeLabel:SetText("Expires: EXPIRED")
                break
            end

            TimeLabel:SetText("Expires: " .. formatTime(left))
            task.wait(1)
        end
    end)
end


local MainGroupLeft = Tabs.Main:AddLeftGroupbox("Main","globe")


local SettingsGroupLeft = Tabs.Settings:AddLeftGroupbox('UI', 'app-window')

SettingsGroupLeft:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})

local Options = Library.Options
local Toggles = Library.Toggles
 
-- Watermark Toggle

local MyToggle = SettingsGroupLeft:AddToggle("MyToggle", {
    Text = "Watermark",
    Default = true,
})
 
Toggles.MyToggle:OnChanged(function(state)
    DraggableLabel:SetVisible(state)
end)

local Options = Library.Options
local Toggles = Library.Toggles

-- Custom Cursor Toggle

local MyToggle = SettingsGroupLeft:AddToggle("MyToggle", {
    Text = "Custom Cursor",
    Default = false,
})

Toggles.MyToggle:OnChanged(function(state)
    Library.ShowCustomCursor = state
end)

SettingsGroupLeft:AddDivider()

-- Dpi Dropdown

SettingsGroupLeft:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})



-- Unload
SettingsGroupLeft:AddDivider()


SettingsGroupLeft:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightControl", NoUI = true, Text = "Menu keybind" })


SettingsGroupLeft:AddButton('Unload', function()
    Library:Unload()
end)


Library.ToggleKeybind = Options.MenuKeybind 


-- ================================
-- SaveManager & ThemeManager
-- ================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("Cryx")
SaveManager:SetFolder("Cryx/Example")
SaveManager:SetSubFolder("")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig("")