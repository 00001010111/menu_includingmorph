local Players = game:GetService("Players")

local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.MorphMenu.Utils.Comm)
local ExtensionManager = require(ReplicatedStorage:FindFirstChild("MorphMenu"):FindFirstChild("ExtensionManager"))
local MorphCharacter = require(ReplicatedStorage.MorphMenu.Utils.MorphCharacter)

local MorphMenuComm = Comm.ServerComm.new(ReplicatedStorage, "MorphComm")

local playerMorphCache = {}

local function morphPlayer(player, morph)
	if not morph then
		return
	end

	ExtensionManager:RunSignal("BeforeMorphCharacter", player, morph)
	if morph.Name ~= "Own Character" then
		MorphCharacter(player.Character, morph)
	end
	ExtensionManager:RunSignal("MorphCharacter", player, morph)
end

local function playerAdded(player)
	player.CharacterAppearanceLoaded:Connect(function()
		local cache = playerMorphCache[player]

		if not cache then
			ExtensionManager:RunSignal("CharacterLoaded", player)
			return
		end

		morphPlayer(player, playerMorphCache[player].morph)
		ExtensionManager:RunSignal("CharacterLoaded", player, cache.morph)
	end)
end

local function playerRemoving(player)
	playerMorphCache[player] = nil
end

local function spawnPlayer(player, teamObject)
	player.Team = teamObject
	wait()
	player:LoadCharacter()
end

MorphMenuComm:BindFunction("SpawnRequest", function(player, team, division, morph)
	if not player or not team then
		return false
	end

	if division and not division:IsDescendantOf(team) then
		return false
	end

	if morph and not morph:IsDescendantOf(division) then
		return false
	end

	local teamObject = Teams:FindFirstChild(team.Name)

	if not teamObject then
		return false
	end

	local canJoinTeam = ExtensionManager:RunExtensionCommand("CanJoinTeam", player, team)

	if not canJoinTeam then
		return false
	end

	if #team:GetChildren() == 0 then
		playerMorphCache[player] = {
			team = teamObject,
		}

		spawnPlayer(player, teamObject)
		return true
	end

	local canJoinDivision = ExtensionManager:RunExtensionCommand("CanJoinTeam", player, division)

	if not canJoinDivision then
		return false
	end

	local canWearMorph = ExtensionManager:RunExtensionCommand("CanWearMorph", player, morph)

	if not canWearMorph then
		return
	end

	spawnPlayer(player, teamObject)
	morphPlayer(player, morph)

	playerMorphCache[player] = {
		morph = morph,
		team = teamObject,
	}

	ExtensionManager:RunSignal("CharacterLoaded", player, morph)

	return true
end)

for _, plr in pairs(Players:GetPlayers()) do
	playerAdded(plr)
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
