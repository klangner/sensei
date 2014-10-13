-- -----------------------------------------------------------------------------
-- Shaman status
-- -----------------------------------------------------------------------------
local FLAME_SHOCK = "Flame Shock"

ShamanStats = {}
ShamanStats.__index = ShamanStats
setmetatable(ShamanStats, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})
function ShamanStats.new()
	local self = setmetatable({}, ShamanStats)
	self.isIncombat = false
	self.stats = Stats()
	self:reset()
	return self
end

function ShamanStats:reset()
	self.stats:reset()
	self.stats:initBuff(FLAME_SHOCK)
end

function ShamanStats:updateState()
	self.stats:updateState()
end

function ShamanStats:setCombatState(state)
	self.stats:setCombatState(state)
end
