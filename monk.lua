-- -----------------------------------------------------------------------------
-- Monk status
-- -----------------------------------------------------------------------------
local TIGER_POWER = "Tiger Power"

MonkStats = {}
MonkStats.__index = MonkStats
setmetatable(MonkStats, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})
function MonkStats.new()
	local self = setmetatable({}, MonkStats)
	self.isIncombat = false
	self.stats = Stats()
	self:reset()
	return self
end

function MonkStats:reset()
	self.stats:reset()
	self.stats:initBuff(TIGER_POWER)
end

function MonkStats:updateState()
	self.stats:updateState()
end

function MonkStats:setCombatState(state)
	print("Monk combat status")
	self.stats:setCombatState(state)
end
