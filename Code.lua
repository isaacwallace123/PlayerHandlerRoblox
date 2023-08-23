local Players = {}
local Meta = {__index = require(script.Funcs)}

function Added(Player)
	local self = setmetatable({
		Player = Player,
		UserId = Player.UserId
	},Meta)
	
	Player.CharacterAppearanceLoaded:Connect(function(Character)
		self.Character = Character
		
		xpcall(function()
			self:SetCollisions()
			self:Overhead()
			self:TPToFriend()
		end, function(Error)
			warn("Character - " .. Error)
		end)
	end)
	
	local Data = self:Load()
	
	local Lead = self:NewStat("leaderstats","Folder",Player)
	local Money = self:NewStat("Money","NumberValue",Lead, Data.Stats.Money)

	Data.Stats.Money = Money

	self.Data = Data
	
	self:Print()
	
	Players[Player.UserId] = self
end

function Removed(Player)
	local self = Players[Player.UserId]
	
	if not self then return end
	
	self:Save()
	
	Players[Player.UserId] = nil
end

game.Players.PlayerAdded:Connect(Added)
game.Players.PlayerRemoving:Connect(Removed)

return Players
