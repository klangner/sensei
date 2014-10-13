-- -----------------------------------------------------------------------------
-- Stats
-- -----------------------------------------------------------------------------

Stats = {}
Stats.__index = Stats
setmetatable(Stats, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})
function Stats.new()
	local self = setmetatable({}, Stats)
	self.isIncombat = false
	self:reset()
	return self
end

function Stats:reset()
	self.buffs = {}
 	self.combatStarted = 0
	self.lastCombatTime = 0
	self.totalCombatTime = 0
end

function Stats:initBuff(spell)
	buff = {}
	buff.state = false
	buff.changedTime = 0
	buff.upTime = 0
	buff.totalTime = 0
	self.buffs[spell] = buff
end

function Stats:updateState()
	for name,value in pairs(self.buffs) do
		buff = UnitBuff("player", name);
		if buff and self.isIncombat then
			self:_updateBuff(name, true)
		else
			buff = UnitDebuff("target", name);
			if buff and self.isIncombat then
				self:_updateBuff(name, true)
			else
				self:_updateBuff(name, false)
			end
		end
	end
end

function Stats:_updateBuff(name, state)
	buff = self.buffs[name]
	if buff.state ~= state then
		self.buffs[name].state = state
		if buff.state then
			self.buffs[name].changedTime = time()
		else
			buff.upTime = buff.upTime + (time()-buff.changedTime)
			buff.totalTime = buff.totalTime + buff.upTime
			self.buffs[name] = buff
		end
	end
end

function Stats:setCombatState(state)
	self.isIncombat = state
	self:updateState()
	if self.isIncombat then
		self.combatStarted = time()
		for name,buff in pairs(self.buffs) do
			self.buffs[name].changedTime = time()
			self.buffs[name].upTime = 0
		end
	else
		self.lastCombatTime = time() - self.combatStarted
		self.totalCombatTime = self.totalCombatTime + self.lastCombatTime
		self:_printCombatSummary()
	end
end

function Stats:_printCombatSummary()
	print("Combat time: " .. tostring(self.lastCombatTime) .. " (" .. tostring(self.totalCombatTime) ..")")
	for name,buff in pairs(self.buffs) do
		pct = math.floor(buff.upTime*100/self.lastCombatTime)
		pctTotal = math.floor(buff.totalTime*100/self.totalCombatTime)
		print(name .. ": " .. tostring(pct) .. "% (" .. tostring(pctTotal) .. "%)")
	end
end