local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local GroupRestrictedTeams = {}
GroupRestrictedTeams.Disabled = false

function GroupRestrictedTeams.CanJoinTeam(...)
	local args = { ... }
	local player
	local teamFolder

	if RunService:IsServer() then
		player = args[1]
		teamFolder = args[2]
	else
		player = Players.LocalPlayer
		teamFolder = args[1]
	end

	if not player or not teamFolder then
		return true
	end

	local groupId = teamFolder:GetAttribute("GroupId")

	if groupId then
		local isInGroup = player:IsInGroup(groupId)

		if not isInGroup then
			return false, "You are not in the group!"
		end

		local rankValue = teamFolder:GetAttribute("Rank")

		if rankValue then
			local rankNumber = player:GetRankInGroup(groupId)

			if rankNumber < rankValue then
				return false, "You do not have the required rank!"
			end
		end
	end

	return true
end

return GroupRestrictedTeams
