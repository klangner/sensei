-- -----------------------------------------------------------------------------
-- Warrior status
-- -----------------------------------------------------------------------------
local MORTAL_WOUNDS = "Mortal Wounds"
local WEAKENED_BLOWS = "Weakened Blows"

WarriorStats = {}
WarriorStats.__index = WarriorStats
setmetatable(WarriorStats, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})
function WarriorStats.new()
	local self = setmetatable({}, WarriorStats)
	self.isIncombat = false
	self.stats = Stats()
	self:reset()
	return self
end

function WarriorStats:reset()
	self.stats:reset()
	self.stats:initBuff(MORTAL_WOUNDS)
	self.stats:initBuff(WEAKENED_BLOWS)
end

function WarriorStats:updateState()
	self.stats:updateState()
end

function WarriorStats:setCombatState(state)
	self.stats:setCombatState(state)
end
