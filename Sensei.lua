-- -----------------------------------------------------------------------------
-- Globals
-- -----------------------------------------------------------------------------
local is_active = false
local student = nil


-- -----------------------------------------------------------------------------
-- Events
-- -----------------------------------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("UNIT_AURA")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT")
eventFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")

function SlashCmdList.Sensei(msg, editbox)
	is_active = not is_active
	if is_active then
		print( 'sensei activated' )
	else
		print( 'sensei turned off' )
	end
end
SLASH_Sensei1 = "/sensei"


-- Login
function eventFrame:PLAYER_LOGIN(loadedAddon)
	unitClass = UnitClass("player")
	if unitClass == "Shaman" then
		student = ShamanStats()
	elseif unitClass == "Warrior" then
		student = WarriorStats()
	elseif unitClass == "Monk" then
		student = MonkStats()
	else
		student = RogueStats()
	end
end

-- Enter battlegrounds
function eventFrame:PLAYER_ENTERING_BATTLEGROUND(loadedAddon)
	if is_active and student then
		student:reset()
	end
end

-- Combat started
function eventFrame:PLAYER_REGEN_DISABLED(loadedAddon)
	if is_active then
		student:setCombatState(true)
	end
end

-- End of combat
function eventFrame:PLAYER_REGEN_ENABLED(loadedAddon)
	if is_active then
		student:setCombatState(false)
	end
end

-- Check aura
function eventFrame:UNIT_AURA(loadedAddon, unit_id)
	if is_active and student then
		student:updateState()
	end
end

-- Check aura
function eventFrame:COMBAT_LOG_EVENT(loadedAddon, event, ...)
	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)
	if is_active then
		-- print("type: " .. type)
		if (type=="SPELL_DAMAGE") then
			local spellId, spellName, spellSchool = select(9, ...)
			-- Use the following line in game version 3.0 or higher, for previous versions use the line after
			local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...)

			print("Casted spell " .. spellName)
			if (spellName=="Mind Blast" and critical==true) then -- ==true for clarity only.  Not needed.
				print("Mind Blast Just Critted!");
			end
		end
	end
end


function printDebuffs()
	for i=1,40 do
		local D = UnitDebuff("target",i);
		if D then
			print(i.."="..D)
		end
	end
end

function printBuffs()
	for i=1,40 do
		local D = UnitBuff("player",i);
		if D then
			print(i.."="..D)
		end
	end
end

function updateWarriorState()
	local mortal = UnitDebuff("target", "Mortal Wounds");
	if mortal then
		print("Mortal applied")
	else
		print("No mortal!")
	end
end
