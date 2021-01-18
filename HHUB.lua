pcall(function()
local Config = {
  Visuals = {
    BoxEsp = false,
    CornerBoxEsp = false,
    TracerEsp = false,
    TracersOrigin = "Top",
    FullBright = false,
    EnemyColor = Color3.fromRGB(190, 190, 0),
    TeamColor = Color3.fromRGB(0, 190, 0),
    GunColor = Color3.fromRGB(0, 190, 0),
    BulletTracersColor = Color3.fromRGB(100, 100, 255),
    ImpactPointsColor = Color3.fromRGB(255, 50, 50),
    GunAndArmsColor = Color3.fromRGB(255, 100, 255),
    AlwaysDay = false,
    BulletTracers = false,
    ImpactPoints = false
  },
  Aimbot = {
    Aimbot = false,
    Smoothness = 0.25,
    AimBone = "head",
    RandomAimBone = false,
    MouseTwoDown = false,
    Silent = false,
    VisCheck = false,
    DrawFOV = false,
    FOV = 200,
    SnapLines = false,
    KillAura = false
  },
  GunMods = {
    Recoil = false,
    Spread = false,
    InstaReload = false,
    FireRate = false,
    FireRateSpeed = 2000,
    RainbowGun = false,
    Sway = false,
    Bob = false,
    CombineMags = false
  },
  OldGunModules = {},
  Player = {
    Walkspeed = 16,
    Jumppower = 4,
    Gravity = 0,
    FallDmg = false,
    AlwaysAllowSpawn = false,
    FreeseCharOnGameEnd = false,
    Team = "nigger"
  }
}

local Services = setmetatable({
  LocalPlayer = game:GetService("Players").LocalPlayer,
  Camera = workspace.CurrentCamera,
  Workspace = game:GetService("Workspace")
}, {
  __index = function(self, idx)
    return rawget(self, idx) or game:GetService(idx)
  end
})

local Funcs = {}

function Funcs:Round(number)
  return math.floor(tonumber(number) + 0.5)
end

function Funcs:DrawSquare()
  local Box = Drawing.new("Square")
  Box.Color = Color3.fromRGB(190, 190, 0)
  Box.Thickness = 0.5
  Box.Filled = false
  Box.Transparency = 1
  return Box
end

function Funcs:DrawLine()
  local line = Drawing.new("Line")
  line.Color = Color3.new(190, 190, 0)
  line.Thickness = 0.5
  return line
end

function Funcs:DrawText()
  local text = Drawing.new("Text")
  text.Color = Color3.fromRGB(190, 190, 0)
  text.Size = 20
  text.Outline = true
  text.Center = true
  return text
end

function Funcs:GetCharacter(player)
  return plrs[player]
end

function Funcs:GetLocalCharacter()
  for i,v in pairs(game:GetService("Workspace").Players.Ghosts:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      return v
    end
  end
  for i,v in pairs(game:GetService("Workspace").Players.Phantoms:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      return v
    end
  end
end

local dot = Vector3.new().Dot
local getbodyparts
local gamelogic
local physics
local particle
local network
local camera
local effects
local _old
local solve

for i,v in next, getgc(true) do
  if type(v) == "table" and rawget(v,'step') and rawget(v,'reset') and rawget(v,'new') then
    particle = v;
    __old = v.new;
  end
  if type(v) == "table" and rawget(v,'trajectory') then
    physics = v;
  end
  if type(v) == "table" and rawget(v,'solve') then
    solve = v.solve;
  end
  if type(v) == "table" and rawget(v,'getbodyparts') then
    getbodyparts = v.getbodyparts;
  end
  if type(v) == "table" and rawget(v,'bullethit') and rawget(v,'breakwindow') then
    effects = v;
    _old = v.bullethit;
  end
  if type(v) == "function" then
    for k, x in pairs(debug.getupvalues(v)) do
      if type(x) == "table" then
        if rawget(x, "send") then
          network = x
        elseif rawget(x, "angles") then
          camera = x
        elseif rawget(x, "gammo") then
          gamelogic = x
        end
      end
    end
  end
end

local newphysics = game:GetService("ReplicatedFirst").SharedModules.Old.Utilities.Math.physics:Clone()
newphysics.Parent = Services.Workspace
newphysics.Name = "darkhub on toppppp"
trajectory = require(newphysics).trajectory

function Funcs:IsAlive(character)
  if character and character:FindFirstChild("Head") and character ~= Funcs:GetLocalCharacter() then
    for i, v in pairs(game:GetService("Workspace").Players.Phantoms:GetChildren()) do
      if v == character then
        return true
      end
    end
    for i, v in pairs(game:GetService("Workspace").Players.Ghosts:GetChildren()) do
      if v == character then
        return true
      end
    end
  end
end

local ticket = 0
local Mouse = Services.LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local target = false
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/stdhexs/HideoutHub/master/HideoutHUB.lua"))()
main = lib:Window()
Aimbot = main:Tab('Aimbot')
Esp = main:Tab('Visuals')
GunMods = main:Tab('Gun Mods')
Player = main:Tab('Player')

Aimbot:Toggle('Aimbot',function(state)
  Config.Aimbot.Aimbot = state
end)

Aimbot:Toggle('Silent Aim',function(state)
  Config.Aimbot.Silent = state
end)

Aimbot:Toggle('Visible Check ( USE THIS )',function(state)
  Config.Aimbot.VisCheck = state
end)

Aimbot:Toggle('Knife Kill Aura',function(state)
  Config.Aimbot.KillAura = state
end)

Aimbot:Toggle('Draw FOV',function(state)
  Config.Aimbot.DrawFOV = state
end)

Aimbot:Dropdown(
  "Aim Bone", {'Head','Torso','Random'},
  function(selected)
    if selected == "Random" then
      Config.Aimbot.RandomAimBone = true
    elseif selected == "Head" then
      Config.Aimbot.RandomAimBone = false
      Config.Aimbot.AimBone = "head"
    elseif selected == "Torso" then
      Config.Aimbot.RandomAimBone = false
      Config.Aimbot.AimBone = "rootpart"
    end
  end
)

Aimbot:Slider('Smoothness',0,10,function(number)
  Config.Aimbot.Smoothness = number / 10
end)

Aimbot:Slider('FOV',0,1000,function(number)
  Config.Aimbot.FOV = number
end)

Esp:Toggle('Boxes',function(state)
  Config.Visuals.BoxEsp = state
end)

Esp:Toggle('Corner Boxes',function(state)
  Config.Visuals.CornerBoxEsp = state
end)

Esp:Toggle('Tracers',function(state)
  Config.Visuals.TracerEsp = state
end)

Esp:Dropdown(
  "Tracers Origin",{'Top','Middle','Bottom','Mouse'},
  function(selected)
    Config.Visuals.TracersOrigin = selected
  end
)

Esp:Colorpicker("Team Esp Color",Color3.fromRGB(0, 190, 0), function(color)
  Config.Visuals.TeamColor = color
end)

Esp:Colorpicker("Enemy Esp Color", Color3.fromRGB(190, 190, 0),function(color)
  Config.Visuals.EnemyColor = color
end)

Esp:Label('Other Visuals')

Esp:Toggle('Full Bright',function(state)
  if state == false then
    Config.Visuals.FullBright = true
    pcall(function()
      game:GetService("Lighting").Brightness = 1
      game:GetService("Lighting").FogEnd = 100000
      game:GetService("Lighting").GlobalShadows = true
      game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
    end)
  elseif state == true then
    Config.Visuals.FullBright = false
    pcall(function()
      game:GetService("Lighting").Brightness = 1
      game:GetService("Lighting").FogEnd = 786543
      game:GetService("Lighting").GlobalShadows = false
      game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
    end)
  end
end)

Esp:Toggle('Always Day',function(state)
  Config.Visuals.AlwaysDay = state
end)

Esp:Toggle('Bullet Tracers',function(state)
  Config.Visuals.BulletTracers = state
end)

Esp:Colorpicker("Bullet Tracers Color",Color3.fromRGB(100, 100, 255), function(color)
  Config.Visuals.BulletTracersColor = color
end)

Esp:Toggle('Impact Points',function(state)
  Config.Visuals.ImpactPoints = state
end)

Esp:Colorpicker("Impact Points Color",Color3.fromRGB(255, 50, 50), function(color)
  Config.Visuals.ImpactPointsColor = color
end)

GunMods:Toggle('No Recoil',function(state)
  Config.GunMods.Recoil = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('No Spread',function(state)
  Config.GunMods.Spread = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Insta Reload',function(state)
  Config.GunMods.InstaReload = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Fire Rate',function(state)
  Config.GunMods.FireRate = state
  Funcs:UpdateGuns()
end)

GunMods:Slider('Fire Rate Speed',2000,3000,function(number)
  Config.GunMods.FireRateSpeed = number
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Combine Mags',function(state)
  Config.GunMods.CombineMags = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('Rainbow Gun',function(state)
  Config.GunMods.RainbowGun = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('No Gun Sway',function(state)
  Config.GunMods.Sway = state
  Funcs:UpdateGuns()
end)

GunMods:Toggle('No Gun Bob',function(state)
  Config.GunMods.Bob = state
  Funcs:UpdateGuns()
end)

Player:Slider('Walkspeed',16,65,function(number)
  Config.Player.Walkspeed = number
end)

Player:Slider('Jumppower',4,100,function(number)
  Config.Player.Jumppower = number
end)

Player:Slider('Gravity',0,195,function(number)
  Config.Player.Gravity = number
  game.Workspace.Gravity = 196.19999694824 - Config.Player.Gravity
end)

Player:Toggle('No Fall Damage',function(state)
  Config.Player.FallDmg = state
end)


Player:Toggle('Dont Freeze Character',function(state)
  Config.Player.FreeseCharOnGameEnd = state
end)

local things = Instance.new("Part", Services.Workspace)
things.Name = "things"
things.Transparency = 1

function Funcs:Trace(firstpos, secondpos)
  --local colorSequence = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(Config.Visuals.BulletTracersColor.R, Config.Visuals.BulletTracersColor.G, Config.Visuals.BulletTracersColor.B)), ColorSequenceKeypoint.new(1, Color3.new(Config.Visuals.BulletTracersColor.R, Config.Visuals.BulletTracersColor.G, Config.Visuals.BulletTracersColor.B))})
  local colorSequence = ColorSequence.new(Config.Visuals.BulletTracersColor, Config.Visuals.BulletTracersColor)
  local start = Instance.new("Part", things)
  local endd = Instance.new("Part", things)
  local Attachment = Instance.new("Attachment", start)
  local Attachment2 = Instance.new("Attachment", endd)
  local laser = Instance.new("Beam", start)
  start.Size = Vector3.new(1, 1, 1)
  start.Transparency = 1
  start.CanCollide = false
  start.CFrame = CFrame.new(firstpos)
  start.Anchored = true
  endd.Size = Vector3.new(1, 1, 1)
  endd.Transparency = 1
  endd.CanCollide = false
  endd.CFrame = CFrame.new(secondpos)
  endd.Anchored = true
  laser.FaceCamera = false
  laser.Color = colorSequence
  laser.LightEmission = 0
  laser.LightInfluence = 0
  laser.Width0 = 0.1
  laser.Width1 = 0.1
  laser.Attachment0 = Attachment
  laser.Attachment1 = Attachment2
  delay(1.6, function()
    for i = 0.5, 1.3, 0.2 do
      wait()
      laser.Transparency = NumberSequence.new(i)
    end
    start:Destroy()
    endd:Destroy()
  end)
end

function Funcs:Highlight(pos)
  local highlight = Instance.new("Part", things)
  highlight.Size = Vector3.new(0.4, 0.4, 0.4)
  highlight.Transparency = 0.5
  highlight.CanCollide = false
  highlight.Position = pos
  --highlight.CFrame = CFrame.new(pos)
  highlight.Anchored = true
  highlight.Color = Config.Visuals.ImpactPointsColor
  delay(2, function()
    for i = 1, 10 do
      wait()
      highlight.Transparency = highlight.Transparency + 0.05
    end
    highlight:Destroy()
  end)
end

function Funcs.IsVisible(part)
local ignore = {Services.LocalPlayer.Character, part.Parent, Services.Workspace.Camera}
local ray = {Services.LocalPlayer.Character.HumanoidRootPart.Position, part.Position}
local parts = Services.Camera:GetPartsObscuringTarget(ray, ignore)
if not parts[2] then
  return true
end
end

function Funcs:GetTarget()
  local plr = nil;
  local distance = math.huge;
  for i, v in next, game:GetService('Players'):GetPlayers() do
    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
      if debug.getupvalues(getbodyparts)[1][v] and v.Team ~= game:GetService('Players').LocalPlayer.Team then
        local pos, onScreen = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][v]['head'].Position);
        local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude;
        local vis = Funcs.IsVisible(debug.getupvalues(getbodyparts)[1][v][Config.Aimbot.AimBone])
        if magnitude < distance and magnitude <= Config.Aimbot.FOV and onScreen and Config.Aimbot.VisCheck and vis or magnitude < distance and magnitude <= Config.Aimbot.FOV and onScreen and not Config.Aimbot.VisCheck then
          plr = v;
          distance = magnitude;
        end
      end
    end
  end
  return plr;
end

effects.bullethit = function(self, ...)
  local args = {...}
  if Config.Visuals.ImpactPoints then
    Funcs:Highlight(args[2])
  end
  return _old(self, unpack(args))
end

particle.new = function(data)
  if Config.Aimbot.Silent and gamelogic.currentgun and data.visualorigin == gamelogic.currentgun.barrel.Position then
    local plr = Funcs:GetTarget()
    if plr then
      data.position = debug.getupvalues(getbodyparts)[1][plr][Config.Aimbot.AimBone].Position;
      data.velocity = trajectory(Services.Camera.CFrame.Position, Vector3.new(0, -196.2, 0), debug.getupvalues(getbodyparts)[1][plr][Config.Aimbot.AimBone].Position, gamelogic.currentgun.data.bulletspeed)
    end
  end
  return __old(data)
end

local send = network.send
network.send = function(self, name, ...)
  local args = {...}
  if name == "falldamage" and Config.Player.FallDmg then
    return;
  end
  if name == "newbullets" then
    local target = Funcs:GetTarget()
    if target and debug.getupvalues(getbodyparts)[1][target] and debug.getupvalues(getbodyparts)[1][target].head and Config.Aimbot.Silent then
      local targetPos = debug.getupvalues(getbodyparts)[1][target][Config.Aimbot.AimBone].Position
      local localPos = camera.basecframe * Vector3.new(0, 0, 0.5)
      local dir = trajectory(localPos, Vector3.new(0, -192.6, 0), targetPos, gamelogic.currentgun.data.bulletspeed)
      bulletdata = {
        firepos = localPos,
        camerapos = localPos,
        pitch = 1,
        bullets = {
          {
            dir,
            ticket,
          }
        }
      }
      send(self, "newbullets", bulletdata, tick())
      send(self, "bullethit", target, targetPos, debug.getupvalues(getbodyparts)[1][target][Config.Aimbot.AimBone], ticket)
      Funcs:Trace(gamelogic.currentgun.barrel.Position, targetPos)
      if Config.Visuals.ImpactPoints then
        Funcs:Highlight(targetPos)
      end
      ticket = ticket - 1
    end
    if Config.Visuals.BulletTracers and target == nil and Config.Aimbot.Silent or Config.Visuals.BulletTracers and not Config.Aimbot.Silent then
      Funcs:Trace(gamelogic.currentgun.barrel.Position, args[1]["bullets"][1][1] * args[1]["bullets"][1][2])
    end
  end
  return send(self, name, unpack(args))
end

spawn(function()
  while wait() do
    pcall(function()
      TargetPlayer = Funcs:GetTarget()
      if TargetPlayer and Config.Aimbot.MouseTwoDown and Config.Aimbot.Aimbot and debug.getupvalues(getbodyparts)[1][TargetPlayer] then
        local niggasbone = Services.Camera:WorldToScreenPoint(debug.getupvalues(getbodyparts)[1][TargetPlayer][Config.Aimbot.AimBone].Position)
        local moveto = Vector2.new((niggasbone.X-Mouse.X)*Config.Aimbot.Smoothness,(niggasbone.Y-Mouse.Y)*Config.Aimbot.Smoothness)
        mousemoverel(moveto.X,moveto.Y)
      end
    end)
  end
end)

Mouse.Button2Down:Connect(function()
  Config.Aimbot.MouseTwoDown = true
end)

Mouse.Button2Up:Connect(function()
  Config.Aimbot.MouseTwoDown = false
end)

function Funcs:AddEsp(player)
  local bottomrightone = Funcs:DrawLine()
  local bottomleftone = Funcs:DrawLine()
  local toprightone = Funcs:DrawLine()
  local topleftone = Funcs:DrawLine()
  local toplefttwo = Funcs:DrawLine()
  local bottomlefttwo = Funcs:DrawLine()
  local toprighttwo = Funcs:DrawLine()
  local bottomrighttwo = Funcs:DrawLine()
  local box = Funcs:DrawSquare()
  local tracer = Funcs:DrawLine()
  Services.RunService.Stepped:Connect(function()
    if debug.getupvalues(getbodyparts)[1][player] and Funcs:IsAlive(debug.getupvalues(getbodyparts)[1][player].head.Parent) and player.Team ~= Services.LocalPlayer.Team then
      bottomrightone.Color = Config.Visuals.EnemyColor
      bottomleftone.Color = Config.Visuals.EnemyColor
      toprightone.Color = Config.Visuals.EnemyColor
      topleftone.Color = Config.Visuals.EnemyColor
      toplefttwo.Color = Config.Visuals.EnemyColor
      bottomlefttwo.Color = Config.Visuals.EnemyColor
      toprighttwo.Color = Config.Visuals.EnemyColor
      bottomrighttwo.Color = Config.Visuals.EnemyColor
      box.Color = Config.Visuals.EnemyColor
      tracer.Color = Config.Visuals.EnemyColor
    else
      bottomrightone.Color = Config.Visuals.TeamColor
      bottomleftone.Color = Config.Visuals.TeamColor
      toprightone.Color = Config.Visuals.TeamColor
      topleftone.Color = Config.Visuals.TeamColor
      toplefttwo.Color = Config.Visuals.TeamColor
      bottomlefttwo.Color = Config.Visuals.TeamColor
      toprighttwo.Color = Config.Visuals.TeamColor
      bottomrighttwo.Color = Config.Visuals.TeamColor
      box.Color = Config.Visuals.TeamColor
      tracer.Color = Config.Visuals.TeamColor
    end
    if debug.getupvalues(getbodyparts)[1][player] and Funcs:IsAlive(debug.getupvalues(getbodyparts)[1][player].head.Parent) and debug.getupvalues(getbodyparts)[1][player].rootpart then
      local RootPosition, OnScreen = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][player].rootpart.Position)
      local HeadPosition = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][player].head.Position + Vector3.new(0, 0, 0))
      local LegPosition = Services.Camera:WorldToViewportPoint(debug.getupvalues(getbodyparts)[1][player].rootpart.Position - Vector3.new(0, 5, 0))
      local length = RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)
      local lengthx = RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)
      local size = HeadPosition.Y - LegPosition.Y
      if Config.Visuals.CornerBoxEsp and Funcs:IsAlive(debug.getupvalues(getbodyparts)[1][player].head.Parent) then
        bottomrightone.Visible = OnScreen
        bottomrightone.From = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), length)
        bottomrightone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + (size / 3), length)
        bottomleftone.Visible = OnScreen
        bottomleftone.From = Vector2.new((RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)) + size, length)
        bottomleftone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + ((size / 3) * 2), length)
        toprightone.Visible = OnScreen
        toprightone.From = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), length + size)
        toprightone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + (size / 3), length + size)
        topleftone.Visible = OnScreen
        topleftone.From = Vector2.new((RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2)) + size, length + size)
        topleftone.To = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2) + ((size / 3) * 2), length + size)
        toplefttwo.Visible = OnScreen
        toplefttwo.From = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + size)
        toplefttwo.To = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + ((size / 3) * 2))
        bottomlefttwo.Visible = OnScreen
        bottomlefttwo.From = Vector2.new(lengthx, (RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2))
        bottomlefttwo.To = Vector2.new(lengthx, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + (size / 3))
        toprighttwo.Visible = OnScreen
        toprighttwo.From = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + size)
        toprighttwo.To = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + ((size / 3) * 2))
        bottomrighttwo.Visible = OnScreen
        bottomrighttwo.From = Vector2.new(lengthx + size, (RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2))
        bottomrighttwo.To = Vector2.new(lengthx + size, (RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2)) + (size / 3))
      else
        bottomrightone.Visible = false
        bottomleftone.Visible = false
        toprightone.Visible = false
        topleftone.Visible = false
        toplefttwo.Visible = false
        bottomlefttwo.Visible = false
        toprighttwo.Visible = false
        bottomrighttwo.Visible = false
      end
      if Config.Visuals.BoxEsp then
        box.Visible = OnScreen
        box.Size = Vector2.new(HeadPosition.Y - LegPosition.Y, HeadPosition.Y - LegPosition.Y)
        box.Position = Vector2.new(RootPosition.X - ((HeadPosition.Y - LegPosition.Y) / 2), RootPosition.Y - ((HeadPosition.Y - LegPosition.Y) / 2))
      else
        box.Visible = false
      end
      if Config.Visuals.TracerEsp then
        tracer.Visible = OnScreen
        if Config.Visuals.TracersOrigin == "Top" then
          tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 0)
          tracer.From = Vector2.new(RootPosition.X - 1, RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2)
        elseif Config.Visuals.TracersOrigin == "Middle" then
          tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, Services.Camera.ViewportSize.Y / 2)
          tracer.From = Vector2.new(RootPosition.X - 1, (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) - ((HeadPosition.Y - LegPosition.Y) / 2))
        elseif Config.Visuals.TracersOrigin == "Bottom" then
          tracer.To = Vector2.new(Services.Camera.ViewportSize.X / 2, 1000)
          tracer.From = Vector2.new(RootPosition.X - 1, RootPosition.Y - (HeadPosition.Y - LegPosition.Y) / 2)
        elseif Config.Visuals.TracersOrigin == "Mouse" then
          tracer.To = game:GetService('UserInputService'):GetMouseLocation();
          tracer.From = Vector2.new(RootPosition.X - 1, (RootPosition.Y + (HeadPosition.Y - LegPosition.Y) / 2) - ((HeadPosition.Y - LegPosition.Y) / 2))
        end
      else
        tracer.Visible = false
      end
    else
      bottomrightone.Visible = false
      bottomleftone.Visible = false
      toprightone.Visible = false
      topleftone.Visible = false
      toplefttwo.Visible = false
      bottomlefttwo.Visible = false
      toprighttwo.Visible = false
      bottomrighttwo.Visible = false
      box.Visible = false
      tracer.Visible = false
    end
  end)
end

for i, v in pairs(Services.Players:GetPlayers()) do
  if v ~= Services.LocalPlayer then
    Funcs:AddEsp(v)
  end
end

Services.Players.PlayerAdded:Connect(function(player)
  if v ~= Services.LocalPlayer then
    Funcs:AddEsp(player)
  end
end)

for i, v in pairs(game:GetService("ReplicatedStorage").GunModules:GetChildren()) do
  rv = require(v)
  Config.OldGunModules[v] = {}
  Config.OldGunModules[v]["aimrotkickmin"] = rv.aimrotkickmin
  Config.OldGunModules[v]["aimrotkickmax"] = rv.aimrotkickmax
  Config.OldGunModules[v]["aimtranskickmin"] = rv.aimtranskickmin
  Config.OldGunModules[v]["aimtranskickmax"] = rv.aimtranskickmax
  Config.OldGunModules[v]["aimcamkickmin"] = rv.aimcamkickmin
  Config.OldGunModules[v]["aimcamkickmax"] = rv.aimcamkickmax
  Config.OldGunModules[v]["camkickspeed"] = rv.camkickspeed
  Config.OldGunModules[v]["rotkickmin"] = rv.rotkickmin
  Config.OldGunModules[v]["rotkickmax"] = rv.rotkickmax
  Config.OldGunModules[v]["transkickmin"] = rv.transkickmin
  Config.OldGunModules[v]["transkickmax"] = rv.transkickmax
  Config.OldGunModules[v]["camkickmin"] = rv.camkickmin
  Config.OldGunModules[v]["camkickmax"] = rv.camkickmax
  Config.OldGunModules[v]["aimcamkickspeed"] = rv.aimcamkickspeed
  Config.OldGunModules[v]["modelkickspeed"] = rv.modelkickspeed
  Config.OldGunModules[v]["modelrecoverspeed"] = rv.modelrecoverspeed
  Config.OldGunModules[v]["hipfirespread"] = rv.hipfirespread
  Config.OldGunModules[v]["hipfirestability"] = rv.hipfirestability
  Config.OldGunModules[v]["hipfirespreadrecover"] = rv.hipfirespreadrecover
  Config.OldGunModules[v]["crosssize"] = rv.crosssize
  Config.OldGunModules[v]["crossexpansion"] = rv.crossexpansion
  Config.OldGunModules[v]["swayamp"] = rv.swayamp
  Config.OldGunModules[v]["swayspeed"] = rv.swayspeed
  Config.OldGunModules[v]["steadyspeed"] = rv.steadyspeed
  Config.OldGunModules[v]["breathspeed"] = rv.breathspeed
  Config.OldGunModules[v]["variablefirerate"] = rv.variablefirerate
  Config.OldGunModules[v]["firerate"] = rv.firerate
  Config.OldGunModules[v]["firemodes"] = rv.firemodes
  Config.OldGunModules[v]["firemodes"] = rv.firemodes
  if rv["magsize"] and rv["sparerounds"] then
    Config.OldGunModules[v]["magsize"] = rv.magsize
    Config.OldGunModules[v]["sparerounds"] = rv.sparerounds
  end
  if rv.animations and rv.animations.reload then
    for k, j in pairs(rv.animations) do
      if string.find(string.lower(k), "reload") then
        Config.OldGunModules[v]["timescale"] = rv.animations[k].timescale
      end
    end
  end
end

function Funcs:UpdateGuns()
  for i,s in pairs(game:GetService("ReplicatedStorage").GunModules:GetChildren()) do
    rs = require(s)
    if Config.GunMods.Recoil then
      rs.aimrotkickmin = Vector3.new(0, 0, 0)
      rs.aimrotkickmax = Vector3.new(0, 0, 0)
      rs.aimtranskickmin = Vector3.new(0, 0, 0)
      rs.aimtranskickmax = Vector3.new(0, 0, 0)
      rs.aimcamkickmin = Vector3.new(0, 0, 0)
      rs.aimcamkickmax = Vector3.new(0, 0, 0)
      rs.camkickspeed = 99999
      rs.rotkickmin = Vector3.new(0, 0, 0)
      rs.rotkickmax = Vector3.new(0, 0, 0)
      rs.transkickmin = Vector3.new(0, 0, 0)
      rs.transkickmax = Vector3.new(0, 0, 0)
      rs.camkickmin = Vector3.new(0, 0, 0)
      rs.camkickmax = Vector3.new(0, 0, 0)
      rs.aimcamkickspeed = 99999
      rs.modelkickspeed = 99999
      rs.modelrecoverspeed = 99999
    else
      rs.aimrotkickmin = Config.OldGunModules[s].aimrotkickmin
      rs.aimrotkickmax = Config.OldGunModules[s].aimrotkickmax
      rs.aimtranskickmin = Config.OldGunModules[s].aimtranskickmin
      rs.aimtranskickmax = Config.OldGunModules[s].aimtranskickmax
      rs.aimcamkickmin = Config.OldGunModules[s].aimcamkickmin
      rs.aimcamkickmax = Config.OldGunModules[s].aimcamkickmax
      rs.camkickspeed = Config.OldGunModules[s].camkickspeed
      rs.rotkickmin = Config.OldGunModules[s].rotkickmin
      rs.rotkickmax = Config.OldGunModules[s].rotkickmax
      rs.transkickmin = Config.OldGunModules[s].transkickmin
      rs.transkickmax = Config.OldGunModules[s].transkickmax
      rs.camkickmin = Config.OldGunModules[s].camkickmin
      rs.camkickmax = Config.OldGunModules[s].camkickmax
      rs.aimcamkickspeed = Config.OldGunModules[s].aimcamkickspeed
      rs.modelkickspeed = Config.OldGunModules[s].modelkickspeed
      rs.modelrecoverspeed = Config.OldGunModules[s].modelrecoverspeed
    end
    if Config.GunMods.Spread then
      rs.hipfirespread = 0.00001
      rs.hipfirestability = 0.00001
      rs.hipfirespreadrecover = 99999
      rs.crosssize = 5
      rs.crossexpansion = 0.00001
    else
      rs.hipfirespread = Config.OldGunModules[s].hipfirespread
      rs.hipfirestability = Config.OldGunModules[s].hipfirestability
      rs.hipfirespreadrecover = Config.OldGunModules[s].hipfirespreadrecover
      rs.crosssize = Config.OldGunModules[s].crosssize
      rs.crossexpansion = Config.OldGunModules[s].crossexpansion
    end
    if Config.GunMods.Sway then
      rs.swayamp = 0.00001
      rs.swayspeed = 0.00001
      rs.steadyspeed = 0.00001
      rs.breathspeed = 0.00001
    else
      rs.swayamp = Config.OldGunModules[s].swayamp
      rs.swayspeed = Config.OldGunModules[s].swayspeed
      rs.steadyspeed = Config.OldGunModules[s].steadyspeed
      rs.breathspeed = Config.OldGunModules[s].breathspeed
    end
    if Config.GunMods.FireRate then
      rs.variablefirerate = false
      rs.firerate = Config.GunMods.FireRateSpeed
      rs.firemodes = {true}
    else
      rs.variablefirerate = Config.OldGunModules[s].variablefirerate
      rs.firerate = Config.OldGunModules[s].firerate
      rs.firemodes = Config.OldGunModules[s].firemodes
    end
    if Config.GunMods.CombineMags and rs["magsize"] and rs["sparerounds"] then
      rs.magsize = rs.magsize + rs.sparerounds
      rs.sparerounds = 0
    elseif rs["magsize"] and rs["sparerounds"] then
      rs.magsize = Config.OldGunModules[s].magsize
      rs.sparerounds = Config.OldGunModules[s].sparerounds
    end
    if Config.GunMods.InstaReload then
      if rs.animations and rs.animations.reload then
        for k, v in pairs(rs.animations) do
          if string.find(string.lower(k), "reload") then
            rs.animations[k].timescale = 0
          end
        end
      end
    else
      if rs.animations and rs.animations.reload then
        for k, v in pairs(rs.animations) do
          if string.find(string.lower(k), "reload") then
            rs.animations[k].timescale = Config.OldGunModules[s].timescale
          end
        end
      end
    end
  end
end

for a,b in pairs(getgc(true)) do
  if typeof(b) == "table" and rawget(b,"setbasewalkspeed") then
    game:GetService("RunService").Stepped:Connect(function()
      b:setbasewalkspeed(Config.Player.Walkspeed)
    end)
  end
end

for a,b in pairs(getgc(true)) do
  if typeof(b) == "table" and rawget(b,"jump") then
    h = b.jump
    function b.jump(...)
      local o = {...}
      o[2] = Config.Player.Jumppower
      return h(unpack(o))
    end
  end
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(190, 190, 0)
FOVCircle.Thickness = 0.5
FOVCircle.NumSides = 16
FOVCircle.Filled = false
FOVCircle.Transparency = 1

spawn(function()
  while wait(0.2) do
    if Config.Aimbot.KillAura then
      pcall(function()
        for i, v in next, game:GetService('Players'):GetPlayers() do
          if v.Name ~= game:GetService('Players').LocalPlayer.Name then
            if debug.getupvalues(getbodyparts)[1][v] and debug.getupvalues(getbodyparts)[1][v]['head'] then
              mag  = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - debug.getupvalues(getbodyparts)[1][v]['head'].Position).magnitude
              if mag < 14 then
                network:send('knifehit',v,tick(),debug.getupvalues(getbodyparts)[1][v]['head'])
              end    
            end
          end
        end
      end)
    end
  end
end)

Services.RunService.Stepped:Connect(function()
  if Config.Player.FreeseCharOnGameEnd then
    game:GetService("ReplicatedStorage").ServerSettings.ShowResults.Value = false
  end
  if Config.Player.AlwaysAllowSpawn then
    game:GetService("ReplicatedStorage").ServerSettings.AllowSpawn.Value = true
  end
  if Config.Aimbot.RandomAimBone then
    random = math.random(1,2)
    if random == 1 then
      Config.Aimbot.AimBone = "head"
    elseif random == 2 then
      Config.Aimbot.AimBone = "rootpart"
    end
  end
  if Config.GunMods.RainbowGun then
    for a,b in pairs(workspace.Camera:GetChildren()) do 
      for c,d in pairs(game:GetService("ReplicatedStorage").GunModels:GetChildren()) do ---Darkhub skidded this
        if b.Name == d.Name then 
          for e,f in pairs(b:GetChildren()) do 
            if f:IsA("BasePart") then 
              f.Color = Color3.fromHSV(tick()%5/5,1,1)
              f.Material = "Neon"
            end
          end
        end
      end
    end
  end
  if Config.GunMods.Bob then
    pcall(function()
      if type(debug.getupvalue(gamelogic.currentgun.step, 28)) == 'function' then
        debug.setupvalue(gamelogic.currentgun.step, 28, function() return CFrame.new() end)
      end
    end)
  end
  FOVCircle.Position = game:GetService('UserInputService'):GetMouseLocation();
  FOVCircle.Radius = Config.Aimbot.FOV
  if Config.Aimbot.DrawFOV then
    FOVCircle.Visible = true
  else
    FOVCircle.Visible = false
  end
  for i,v in pairs(game:GetService("Workspace").Players.Ghosts:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      Config.Player.Team = "Phantoms"
    end
  end
  for i,v in pairs(game:GetService("Workspace").Players.Phantoms:GetChildren()) do
    if v:FindFirstChild("Humanoid") then
      Config.Player.Team = "Ghosts"
    end
  end
end)
end)
