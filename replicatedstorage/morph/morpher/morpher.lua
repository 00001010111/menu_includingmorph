is this open sourced.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local function removeAndGiveIfExists(character, morph, name)
	local characterItem = character:FindFirstChild(name)
	local morphItem = morph:FindFirstChild(name)

	if morphItem and characterItem then
		characterItem:Destroy()
	end

	if morphItem then
		morphItem:Clone().Parent = character
	end
end

local function removeOldMorph(character)
	local oldMorph = character:FindFirstChild("Morph")

	if oldMorph then
		oldMorph:Destroy()
	end

	for _, v in pairs(character:GetChildren()) do
		if v:IsA("Clothing") or v:IsA("Accessory") or v:IsA("ShirtGraphic") then
			v:Destroy()
		end
	end
end

local function addBodyPartArmor(morph: Folder, bodyPart: BasePart)
	local armour: Model = morph:FindFirstChild(bodyPart.Name)

	if not armour then
		return
	end

	if not armour:IsA("Model") then
		return
	end

	local newArmour = armour:Clone()
	local primaryPart = newArmour.PrimaryPart

	if not primaryPart then
		local middle = newArmour:FindFirstChild("Middle")

		if not middle then
			warn("Morph does not have a primary part or a middle part")
			return
		end
		newArmour.PrimaryPart = middle
		primaryPart = middle
	end

	newArmour:SetPrimaryPartCFrame(bodyPart.CFrame)

	for _, v in pairs(newArmour:GetChildren()) do
		local weld = Instance.new("Weld")
		weld.Part0 = v
		weld.Part1 = primaryPart
		weld.C0 = primaryPart.CFrame:ToObjectSpace(v.CFrame):Inverse()
		weld.Parent = v

		v.CanCollide = false
		v.Anchored = false
	end

	local weld = Instance.new("Weld")
	weld.Part0 = primaryPart
	weld.Part1 = bodyPart
	weld.C0 = CFrame.new()
	weld.Parent = primaryPart

	primaryPart.CanCollide = false
	primaryPart.Anchored = false

	local shouldHide = newArmour:GetAttribute("HideBodyPart")

	bodyPart.Transparency = if shouldHide then 1 else 0

	for _, v in pairs(bodyPart:GetChildren()) do
		if v:IsA("Decal") then
			v.Transparency = if shouldHide then 1 else 0
		end
	end

	return newArmour
end

return function(character, morph)
	if RunService:IsClient() then
		if not morph or morph.Name == "Own Character" then
			morph = Players.LocalPlayer.Character
		end
	end

	removeOldMorph(character)

	removeAndGiveIfExists(character, morph, "Shirt")
	removeAndGiveIfExists(character, morph, "Pants")

	local morphHolder = Instance.new("Model")
	for _, v in pairs(character:GetChildren()) do
		if v:IsA("BasePart") then
			local newArmour = addBodyPartArmor(morph, v)

			if not newArmour then
				continue
			end

			newArmour.Parent = morphHolder
		end
	end

	morphHolder.Name = "Morph"
	morphHolder.Parent = character
end