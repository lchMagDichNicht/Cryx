--// Cryx Loading / Start Animation (premium)
--// Works as LocalScript OR executor injected (uses CoreGui)
--// Logo: rbxassetid://88682207577999

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local LOGO_ID = "rbxassetid://88682207577999"

-- Optional: exploit gui parent support
local function getGuiParent()
    local ok, hui = pcall(function()
        return (gethui and gethui()) or (syn and syn.protect_gui and CoreGui) or CoreGui
    end)
    if ok and hui then return hui end
    return CoreGui
end

local parent = getGuiParent()

-- Cleanup old
pcall(function()
    local old = parent:FindFirstChild("CryxLoadingUI")
    if old then old:Destroy() end
end)

-- Blur effect
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "CryxLoadingUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- if syn.protect_gui exists, protect it
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(gui) end
end)

gui.Parent = parent

local bg = Instance.new("Frame")
bg.Name = "Background"
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
bg.BackgroundTransparency = 1
bg.Parent = gui

-- subtle gradient
local grad = Instance.new("UIGradient")
grad.Rotation = 90
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 8)),
})
grad.Parent = bg

-- Vignette-ish overlay
local vignette = Instance.new("Frame")
vignette.Size = UDim2.fromScale(1, 1)
vignette.BackgroundTransparency = 1
vignette.Parent = bg
local vgrad = Instance.new("UIGradient")
vgrad.Rotation = 0
vgrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.35),
    NumberSequenceKeypoint.new(0.5, 1),
    NumberSequenceKeypoint.new(1, 0.35),
})
vgrad.Parent = vignette

local center = Instance.new("Frame")
center.AnchorPoint = Vector2.new(0.5, 0.5)
center.Position = UDim2.fromScale(0.5, 0.5)
center.Size = UDim2.fromOffset(520, 260)
center.BackgroundTransparency = 1
center.Parent = bg

local logoWrap = Instance.new("Frame")
logoWrap.AnchorPoint = Vector2.new(0.5, 0.5)
logoWrap.Position = UDim2.fromScale(0.5, 0.42)
logoWrap.Size = UDim2.fromOffset(120, 120)
logoWrap.BackgroundTransparency = 1
logoWrap.Parent = center

local glow = Instance.new("ImageLabel")
glow.Name = "Glow"
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.Position = UDim2.fromScale(0.5, 0.5)
glow.Size = UDim2.fromScale(1.55, 1.55)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://4996891970" -- soft circle glow (Roblox decal)
glow.ImageTransparency = 0.75
glow.Parent = logoWrap

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.Position = UDim2.fromScale(0.5, 0.5)
logo.Size = UDim2.fromScale(1, 1)
logo.BackgroundTransparency = 1
logo.Image = LOGO_ID
logo.ImageTransparency = 1
logo.Parent = logoWrap

local title = Instance.new("TextLabel")
title.Name = "Title"
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Position = UDim2.fromScale(0.5, 0.67)
title.Size = UDim2.fromOffset(520, 40)
title.BackgroundTransparency = 1
title.Text = "CRYX"
title.TextTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 34
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.Parent = center

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
subtitle.Position = UDim2.fromScale(0.5, 0.79)
subtitle.Size = UDim2.fromOffset(520, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Initializing..."
subtitle.TextTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 16
subtitle.TextColor3 = Color3.fromRGB(190, 190, 200)
subtitle.Parent = center

-- Progress bar
local barBack = Instance.new("Frame")
barBack.Name = "BarBack"
barBack.AnchorPoint = Vector2.new(0.5, 0.5)
barBack.Position = UDim2.fromScale(0.5, 0.92)
barBack.Size = UDim2.fromOffset(420, 10)
barBack.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
barBack.BackgroundTransparency = 1
barBack.Parent = center

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBack

local barFill = Instance.new("Frame")
barFill.Name = "BarFill"
barFill.Size = UDim2.fromScale(0, 1)
barFill.BackgroundColor3 = Color3.fromRGB(235, 235, 255)
barFill.BackgroundTransparency = 1
barFill.Parent = barBack

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local barGrad = Instance.new("UIGradient")
barGrad.Rotation = 0
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 120, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(110, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 210)),
})
barGrad.Parent = barFill

-- Small tip text
local tip = Instance.new("TextLabel")
tip.Name = "Tip"
tip.AnchorPoint = Vector2.new(0.5, 0.5)
tip.Position = UDim2.fromScale(0.5, 1.05)
tip.Size = UDim2.fromOffset(520, 26)
tip.BackgroundTransparency = 1
tip.Text = "Press Insert to toggle UI"
tip.TextTransparency = 1
tip.Font = Enum.Font.Gotham
tip.TextSize = 14
tip.TextColor3 = Color3.fromRGB(140, 140, 155)
tip.Parent = center

-- Tween helpers
local function tw(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- Animate dots in subtitle
local running = true
task.spawn(function()
    local dots = {".", "..", "..."}
    local i = 1
    while running do
        subtitle.Text = "Loading" .. dots[i]
        i = (i % #dots) + 1
        task.wait(0.35)
    end
end)

-- Main animation sequence
do
    -- fade in bg + blur
    tw(blur, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 14})
    tw(bg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    tw(vignette, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})

    -- logo pop in
    logoWrap.Size = UDim2.fromOffset(92, 92)
    tw(logoWrap, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(130, 130)})
    tw(logo, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
    tw(glow, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.25})

    -- title/subtitle/bar fade in
    tw(title, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    tw(subtitle, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    tw(barBack, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    tw(barFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    tw(tip, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})

    -- glow pulse loop
    local pulseConn
    task.spawn(function()
        local grow = true
        while running do
            if grow then
                tw(glow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0.15,
                    Rotation = 6,
                    Size = UDim2.fromScale(1.75, 1.75),
                })
            else
                tw(glow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0.32,
                    Rotation = -6,
                    Size = UDim2.fromScale(1.55, 1.55),
                })
            end
            grow = not grow
            task.wait(0.82)
        end
    end)

    -- progress simulation (du kannst das später an echte Loads koppeln)
    local steps = {
        {p=0.12, t="Checking environment..."},
        {p=0.28, t="Loading modules..."},
        {p=0.48, t="Setting up UI..."},
        {p=0.66, t="Injecting hooks..."},
        {p=0.82, t="Finalizing..."},
        {p=1.00, t="Done."},
    }

    for _, s in ipairs(steps) do
        title.Text = "CRYX"
        tip.Text = ("Cryx • %d%%"):format(math.floor(s.p * 100))
        -- smooth fill
        tw(barFill, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(s.p, 1)})
        -- small bounce
        tw(logoWrap, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 0.41)})
        tw(logoWrap, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.fromScale(0.5, 0.42)})
        task.wait(0.55)
    end

    -- outro
    task.wait(0.25)
    running = false

    tw(blur, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0})
    tw(bg, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    tw(vignette, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    tw(logo, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1})
    tw(glow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1})
    tw(title, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
    tw(subtitle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
    tw(barBack, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    tw(barFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    tw(tip, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})

    task.wait(0.4)
    blur:Destroy()
    gui:Destroy()
end