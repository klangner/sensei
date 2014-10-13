-- -----------------------------------------------------------------------------
-- Rogue status
-- -----------------------------------------------------------------------------
local SLICE_AND_DICE = "Slice and Dice"


RogueStats = {}
RogueStats.__index = RogueStats
setmetatable(RogueStats, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})
function RogueStats.new()
	local self = setmetatable({}, RogueStats)
	self.isIncombat = false
	self.stats = Stats()
	self:reset()
	return self
end

function RogueStats:reset()
	self.stats:reset()
	self.stats:initBuff(SLICE_AND_DICE)
end

function RogueStats:updateState()
	self.stats:updateState()
end

function RogueStats:setCombatState(state)
	self.stats:setCombatState(state)
end
