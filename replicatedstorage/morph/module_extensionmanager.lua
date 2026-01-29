local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local extensions = {}

local function addExtensionsFromFolder(folder)
	for _, extension in ipairs(folder:GetChildren()) do
		local required = require(extension)

		if required.Disabled then
			continue
		end

		table.insert(extensions, required)
	end
end

if RunService:IsClient() then
	addExtensionsFromFolder(
		Players.LocalPlayer
			:WaitForChild("PlayerScripts")
			:WaitForChild("MorphMenu")
			:WaitForChild("MorphMenuController")
			:WaitForChild("Extensions")
	)
else
	addExtensionsFromFolder(ServerScriptService.MorphMenu.MorphMenuServerController.Extensions)
end

addExtensionsFromFolder(ReplicatedStorage.MorphMenu.SharedExtensions)

local ExtensionManager = {}

function ExtensionManager:GetActiveExtensions()
	return extensions
end

function ExtensionManager:RunExtensionCommand(commandName, ...)
	for _, v in ipairs(extensions) do
		if v[commandName] then
			local ok, value = v[commandName](...)

			if not ok then
				return false, value
			end
		end
	end

	return true
end

function ExtensionManager:RunSignal(commandName, ...)
	for _, v in ipairs(extensions) do
		if v[commandName] then
			v[commandName](...)
		end
	end
end

return ExtensionManager
