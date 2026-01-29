local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PreviewTrooper = {}
PreviewTrooper.Disabled = false

if PreviewTrooper.Disabled then
	return {}
end

local MorphUI = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MorphUI")
local Assets = MorphUI:WaitForChild("Assets")

local player = Players.LocalPlayer

repeat
	task.wait()
until player.Character

local character = player.Character
local PreviewCharacter

if character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R6 then
	PreviewCharacter = Assets:WaitForChild("PreviewCharacterR6"):Clone()
else
	PreviewCharacter = Assets:WaitForChild("PreviewCharacterR15"):Clone()
end

local MorphCharacter = require(ReplicatedStorage.MorphMenu.Utils.MorphCharacter)

PreviewCharacter.Parent = workspace

function PreviewTrooper.MorphCharacter(morph: Model)
	MorphCharacter(PreviewCharacter, morph)
end

return PreviewTrooper
