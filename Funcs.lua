local Phys = game:GetService("PhysicsService")
local DS = game:GetService("DataStoreService"):GetDataStore("TestingDS")
local Players = game:GetService("Players")

Phys:RegisterCollisionGroup("Players")
Phys:CollisionGroupSetCollidable("Players","Players",false)

local Player = {}

function Player:Print()
	print(self)
end

function Player:SetCollisions()
	if not self.Character then return end

	for i,v in pairs(self.Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CollisionGroup = "Players"
		end
	end
end

function Player:TeleportTo(To)
	xpcall(function()
		if not To or not To.UserId or not self.Player:IsFriendsWith(To.UserId) or not self.Character or not self.Character.PrimaryPart or not To.Character or not To.Character.PrimaryPart then return end
		
		self.Character.PrimaryPart.CFrame = To.Character.PrimaryPart.CFrame
	end, function(Error)
		wait(Error)
	end)
end

function Player:TPToFriend()
	for _, Friend in pairs(Players:GetPlayers()) do
		if not Friend:IsFriendsWith(self.UserId) then continue end

		task.wait()
		
		self:TeleportTo(Friend)

		break
	end
end

function Player:Overhead()
	if not self.Character then return end

	local Overhead = script.Overhead:Clone()
	Overhead.Parent = self.Character:WaitForChild("HumanoidRootPart")
	Overhead.Main.PlayerName.Text = self.Player.DisplayName
	Overhead.Enabled = false
end

function Player:NewStat(Name,Type,Parent,Value)
	local Stat = Instance.new(Type)

	Stat.Name = Name
	Stat.Parent = Parent
	if Value then Stat.Value = Value end

	return Stat
end

function Player.Load(self)
	local Loaded = {
		Stats = {},
	}

	local Data = DS:GetAsync("id-"..self.UserId)

	if Data then
		if Data.Stats then
			for Name,Value in pairs(Data.Stats) do
				Loaded.Stats[Name] = Value
			end
		end
	end

	return Loaded
end

function Player.Save(self)
	--if _G.InStudio then return end

	local Save = {
		Stats = {},
	}

	for Name, Stat in pairs(self.Data.Stats) do
		Save.Stats[Name] = Stat.Value
	end

	DS:SetAsync("id-"..self.UserId, Save)
end

return Player
