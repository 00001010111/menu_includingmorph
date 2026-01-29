local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local RankRestrictedMorphs = {"DEV"}
RankRestrictedMorphs.Disabled = false

function RankRestrictedMorphs.CanWearMorph(...)
	local args = { ... }
	local player
	local morphFolder

	if RunService:IsServer() then
		player = args[1]
		morphFolder = args[2]
	else
		player = Players.LocalPlayer
		morphFolder = args[1]
	end

	if not player or not morphFolder then
		return true
	end

	local groupId = morphFolder.Parent:GetAttribute("GroupId")

	if groupId then
		local isInGroup = player:IsInGroup(groupId)

		if not isInGroup then
			return false, "You are not in the group!"
		end

		local rankValue = morphFolder:GetAttribute("Rank")

		if rankValue then
			local rankNumber = player:GetRankInGroup(groupId)

			if rankNumber < rankValue then
				return false, "You do not have the required rank!"
			end
		end
	end

	return true
end

return RankRestrictedMorphs
