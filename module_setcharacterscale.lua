local SetCharacterScale = {}
SetCharacterScale.Disabled = false

function SetCharacterScale.BeforeMorphCharacter(player: Player, morph)
	if morph.Name == "Own Character" then
		return
	end
	
	local Humanoid = player.Character:WaitForChild("Humanoid")
	task.wait()
	local CurrentDescription: HumanoidDescription = Humanoid:GetAppliedDescription()

	CurrentDescription.BodyTypeScale = 0
	CurrentDescription.DepthScale = 1
	CurrentDescription.HeadScale = 1
	CurrentDescription.HeightScale = 1
	CurrentDescription.ProportionScale = 0
	CurrentDescription.WidthScale = 1

	Humanoid:ApplyDescription(CurrentDescription)
end

return SetCharacterScale
