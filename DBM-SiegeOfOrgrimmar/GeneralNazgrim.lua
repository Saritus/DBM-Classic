local mod	= DBM:NewMod(850, "DBM-SiegeOfOrgrimmar", nil, 369)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision$"):sub(12, -3))
mod:SetCreatureID(71515)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 4, 2, 1)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--Nazgrim Core Abilities
local warnSunder					= mod:NewStackAnnounce(143494, 2, nil, mod:IsTank() or mod:IsHealer(), nil, nil, nil, nil, 2)--Will add special warnings and such when know cd and stack count needed for swaps
local warnBonecracker				= mod:NewTargetAnnounce(143638, 2, nil, false, nil, nil, nil, nil, 2)
local warnBattleStance				= mod:NewSpellAnnounce(143589, 2)
local warnBerserkerStance			= mod:NewSpellAnnounce(143594, 3)
local warnDefensiveStanceSoon		= mod:NewAnnounce("warnDefensiveStanceSoon", 4, 143593, nil, nil, true)
local warnDefensiveStance			= mod:NewSpellAnnounce(143593, 4)
local warnAdds						= mod:NewCountAnnounce("ej7920", 3, 2457)
local warnExecute					= mod:NewSpellAnnounce(143502, 4, nil, mod:IsTank())--Heroic
--Nazgrim Rage Abilities
local warnHeroicShockwave			= mod:NewTargetAnnounce(143500, 2)
local warnKorkronBanner				= mod:NewSpellAnnounce(143536, 3)
local warnRavager					= mod:NewSpellAnnounce(143872, 3)
local warnWarSong					= mod:NewSpellAnnounce(143503, 4)
local warnCoolingOff				= mod:NewTargetAnnounce(143484, 1, nil, false, nil, nil, nil, nil, 2)
--Kor'kron Adds
local warnIronstorm					= mod:NewSpellAnnounce(143420, 3, nil, mod:IsMelee())
local warnArcaneShock				= mod:NewSpellAnnounce(143432, 3, nil, false)--Spammy
local warnMagistrike				= mod:NewSpellAnnounce(143431, 3, nil, false)--Spammy
local warnAssasinsMark				= mod:NewTargetAnnounce(143480, 3)
local warnEarthShield				= mod:NewTargetAnnounce(143475, 4, nil, mod:IsMagicDispeller())
local warnEmpoweredChainHeal		= mod:NewCastAnnounce(143473, 4)
local warnHealingTideTotem			= mod:NewSpellAnnounce(143474, 4)

--Nazgrim Core Abilities
local specWarnAdds					= mod:NewSpecialWarningCount("ej7920", not mod:IsHealer())
local specWarnSunder				= mod:NewSpecialWarningStack(143494, mod:IsTank(), 4)
local specWarnSunderOther			= mod:NewSpecialWarningTarget(143494, mod:IsTank())
local specWarnExecute				= mod:NewSpecialWarningSpell(143502, mod:IsTank(), nil, nil, 3)
local specWarnBerserkerStance		= mod:NewSpecialWarningSpell(143594, mod:IsDps())--In case you want to throttle damage some
local specWarnDefensiveStance		= mod:NewSpecialWarningSpell(143593, nil, nil, nil, 3)--Definitely OFF DPS
local specWarnDefensiveStanceAttack	= mod:NewSpecialWarningReflect(143593)
local specWarnDefensiveStanceEnd	= mod:NewSpecialWarningEnd(143593)
--Nazgrim Rage Abilities
local specWarnHeroicShockwave		= mod:NewSpecialWarningYou(143500)
local yellHeroicShockwave			= mod:NewYell(143500)
local specWarnHeroicShockwaveNear	= mod:NewSpecialWarningClose(143500)
local specWarnHeroicShockwaveAll	= mod:NewSpecialWarningSpell(143500, nil, nil, nil, 2)
local specWarnKorkronBanner			= mod:NewSpecialWarningSwitch(143536, mod:IsDps())
local specWarnRavager				= mod:NewSpecialWarningSpell(143872)
local specWarnRavagerMove			= mod:NewSpecialWarningMove(143873)
local specWarnWarSong				= mod:NewSpecialWarningSpell(143503, nil, nil, nil, 2)
--Kor'kron Adds
local specWarnIronstorm				= mod:NewSpecialWarningInterrupt(143420, mod:IsMelee())--Only needs to be interrupted if melee are near it
local specWarnArcaneShock			= mod:NewSpecialWarningInterrupt(143432, false)--Spamy as all fuck, so off by default unless maybe heroic
local specWarnMagistrike			= mod:NewSpecialWarningInterrupt(143431, false)--Spamy as all fuck, so off by default unless maybe heroic
local specWarnEmpoweredChainHeal	= mod:NewSpecialWarningInterrupt(143473, not mod:IsHealer(), nil, nil, 1, 2)--Concerns everyone, if not interrupted will heal boss for a TON
local specWarnAssassinsMark			= mod:NewSpecialWarningYou(143480)
local yellAssassinsMark				= mod:NewYell(143480)
local specWarnAssassinsMarkOther	= mod:NewSpecialWarningTarget(143480, false)
local specWarnEarthShield			= mod:NewSpecialWarningDispel(143475, mod:IsMagicDispeller())
local specWarnHealingTideTotem		= mod:NewSpecialWarningSwitch(143474, false)--Not everyone needs to switch, should be turned on by assigned totem mashing people.

--Nazgrim Core Abilities
local timerAddsCD					= mod:NewNextCountTimer(45, "ej7920", nil, nil, nil, 2457)
local timerSunder					= mod:NewTargetTimer(30, 143494, nil, mod:IsTank() or mod:IsHealer())
local timerSunderCD					= mod:NewCDTimer(8, 143494, nil, mod:IsTank())
local timerExecuteCD				= mod:NewCDTimer(18, 143502, nil, mod:IsTank())
local timerBoneCD					= mod:NewCDTimer(30, 143638, nil, false, nil, nil, nil, nil, nil, nil, 2)
local timerBattleStanceCD			= mod:NewNextTimer(60, 143589)
local timerBerserkerStanceCD		= mod:NewNextTimer(60, 143594)
local timerDefensiveStanceCD		= mod:NewNextTimer(60, 143593)
--Nazgrim Rage Abilities
local timerCoolingOff				= mod:NewBuffFadesTimer(15, 143484)
--Kor'kron Adds
local timerEmpoweredChainHealCD		= mod:NewNextSourceTimer(6, 143473)

local countdownAdds					= mod:NewCountdown(45, "ej7920", not mod:IsHealer(), nil, nil, nil, nil, 2)
local countdownCoolingOff			= mod:NewCountdownFades(15, 143484, nil, nil, nil, nil, true)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:AddSetIconOption("SetIconOnAdds", "ej7920", false, true)
mod:AddInfoFrameOption("ej7909")

local addsCount = 0
local UnitName, UnitExists, UnitGUID, UnitDetailedThreatSituation = UnitName, UnitExists, UnitGUID, UnitDetailedThreatSituation
local dotWarned = {}
local defensiveActive = false
local allForcesReleased = false
local sunder = GetSpellInfo(143494)

local addsTable = {
	[71519] = 7,--Shaman
	[71517] = 6,--Arcweaver
	[71518] = 1,--Assassin
	[71516] = 2,--Iron Blade
	[71556] = 4,--Sniper (Heroic)
}

local bossPower = 0--Will be moved into updateinfoframe function when test code removed
local function updateInfoFrame()
	local lines = {}
	if UnitExists("boss1") then
		bossPower = UnitPower("boss1")
	end
	if bossPower < 50 then
		lines["|cFF088A08"..GetSpellInfo(143500).."|r"] = bossPower--Green
		lines[GetSpellInfo(143536)] = 50
		lines[GetSpellInfo(143503)] = 70
		lines[GetSpellInfo(143872)] = 100
	elseif bossPower < 70 then
		lines[GetSpellInfo(143500)] = 25
		lines["|cFF088A08"..GetSpellInfo(143536).."|r"] = bossPower--Green (Would yellow be too hard to see on this?)
		lines[GetSpellInfo(143503)] = 70
		lines[GetSpellInfo(143872)] = 100
	elseif bossPower < 100 then
		lines[GetSpellInfo(143500)] = 25
		lines[GetSpellInfo(143536)] = 50
		lines["|cFF088A08"..GetSpellInfo(143503).."|r"] = bossPower--Green (Maybe change to orange?)
		lines[GetSpellInfo(143872)] = 100
	elseif bossPower == 100 then
		lines[GetSpellInfo(143500)] = 25
		lines[GetSpellInfo(143536)] = 50
		lines[GetSpellInfo(143503)] = 70
		lines["|cFFFF0000"..GetSpellInfo(143872).."|r"] = bossPower--Red (definitely work making this one red, it's really the only critically bad one)
	end
	if mod:IsDifficulty("heroic10", "heroic25") then--Same on 10 heroic? TODO, get normal LFR and flex adds info verified
		if addsCount == 0 then
			lines[L.nextAdds] = L.mage..", "..L.rogue..", "..L.warrior
		elseif addsCount == 1 then
			lines[L.nextAdds] = L.shaman..", "..L.rogue..", "..L.hunter
		elseif addsCount == 2 then
			lines[L.nextAdds] = L.mage..", "..L.shaman..", "..L.warrior
		elseif addsCount == 3 then
			lines[L.nextAdds] = L.mage..", "..L.rogue..", "..L.hunter
		elseif addsCount == 4 then
			lines[L.nextAdds] = L.shaman..", "..L.rogue..", "..L.warrior
		elseif addsCount == 5 then
			lines[L.nextAdds] = L.mage..", "..L.shaman..", "..L.hunter
		elseif addsCount == 6 then
			lines[L.nextAdds] = L.rogue..", "..L.hunter..", "..L.warrior
		elseif addsCount == 7 then
			lines[L.nextAdds] = L.mage..", "..L.shaman..", "..L.rogue
		elseif addsCount == 8 then
			lines[L.nextAdds] = L.shaman..", "..L.hunter..", "..L.warrior
		elseif addsCount == 9 then
			lines[L.nextAdds] = L.mage..", "..L.hunter..", "..L.warrior
		else--Already had all 10 adds sets now we're just going to get no more adds (except for 10%)
			lines[""] = ""
		end
	else--Not heroic
		if addsCount == 0 then
			lines[L.nextAdds] = L.mage..", "..L.warrior
		elseif addsCount == 1 then
			lines[L.nextAdds] = L.shaman..", "..L.rogue
		elseif addsCount == 2 then
			lines[L.nextAdds] = L.rogue..", "..L.warrior
		elseif addsCount == 3 then
			lines[L.nextAdds] = L.mage..", "..L.shaman
		elseif addsCount == 4 then
			lines[L.nextAdds] = L.shaman..", "..L.warrior
		elseif addsCount == 5 then
			lines[L.nextAdds] = L.mage..", "..L.rogue
		elseif addsCount == 6 then
			lines[L.nextAdds] = L.mage..", "..L.shaman..", "..L.rogue
		elseif addsCount == 7 then
			lines[L.nextAdds] = L.shaman..", "..L.rogue..", "..L.warrior
		elseif addsCount == 8 then
			lines[L.nextAdds] = L.mage..", "..L.shaman..", "..L.warrior
		elseif addsCount == 9 then
			lines[L.nextAdds] = L.mage..", "..L.rogue..", "..L.warrior
		else--Already had all 10 adds sets now we're just going to get no more adds (except for 10%)
			lines[""] = ""
		end
	end
	return lines
end

--Temp test function
--/script DBM:GetModByName("850"):TestInfo(1, 33)
function mod:TestInfo(wave, power)
	addsCount = wave--Fake current adds wave
	bossPower = power--Fake current boss power
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(GetSpellInfo(143589))
		DBM.InfoFrame:Show(5, "function", updateInfoFrame, true)--Only works if you pass true to disable the sorting.
	end
end

function mod:LeapTarget(targetname, uId)
	if not targetname then return end
	warnHeroicShockwave:Show(targetname)
	if targetname == UnitName("player") then
		specWarnHeroicShockwave:Show()
		yellHeroicShockwave:Yell()
	else
		if uId then
			local x, y = GetPlayerMapPosition(uId)
			if x == 0 and y == 0 then
				SetMapToCurrentZone()
				x, y = GetPlayerMapPosition(uId)
			end
			local inRange = DBM.RangeCheck:GetDistance("player", x, y)
			if inRange and inRange < 8 then--Range guesswork
				specWarnHeroicShockwaveNear:Show(targetname)
			else
				specWarnHeroicShockwaveAll:Show()
			end
		end
	end
end

function mod:OnCombatStart(delay)
	addsCount = 0
	table.wipe(dotWarned)
	defensiveActive = false
	allForcesReleased = false
	timerAddsCD:Start(-delay, 1)
	countdownAdds:Start()
	berserkTimer:Start(-delay)
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end 

function mod:SPELL_CAST_START(args)
	if args.spellId == 143872 then
		warnRavager:Show()
		specWarnRavager:Show()
	elseif args.spellId == 143503 then
		warnWarSong:Show()
		specWarnWarSong:Show()
	elseif args.spellId == 143420 then
		local source = args.sourceName
		warnIronstorm:Show()
		if source == UnitName("target") or source == UnitName("focus") then 
			specWarnIronstorm:Show(source)
		end
	elseif args.spellId == 143431 then
		local source = args.sourceName
		if source == UnitName("target") or source == UnitName("focus") then
			warnMagistrike:Show()
			specWarnMagistrike:Show(source)
		end
	elseif args.spellId == 143432 then
		local source = args.sourceName
		if source == UnitName("target") or source == UnitName("focus") then 
			warnArcaneShock:Show()
			specWarnArcaneShock:Show(source)
		end
	elseif args.spellId == 143473 then
		local source = args.sourceName
		warnEmpoweredChainHeal:Show()
		specWarnEmpoweredChainHeal:Show(source)
		timerEmpoweredChainHealCD:Start(source, args.sourceGUID)
	elseif args.spellId == 143502 then
		warnExecute:Show()
		timerExecuteCD:Start()
		if UnitExists("boss1") and UnitGUID("boss1") == args.sourceGUID and UnitDetailedThreatSituation("player", "boss1") then--threat check instead of target because we may be helping dps adds
			specWarnExecute:Show()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 143589 then
		if defensiveActive then
			defensiveActive = false
			specWarnDefensiveStanceEnd:Show()
		end
		self:UnregisterShortTermEvents()
		warnBattleStance:Show()
		timerBerserkerStanceCD:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(143589))
			DBM.InfoFrame:Show(5, "function", updateInfoFrame, true)
		end
	elseif args.spellId == 143594 then
		warnBerserkerStance:Show()
		specWarnBerserkerStance:Show()
		timerDefensiveStanceCD:Start()
		warnDefensiveStanceSoon:Schedule(55, 5)--Start pre warning with regular warnings only as you don't move at this point yet.
		warnDefensiveStanceSoon:Schedule(56, 4)
		warnDefensiveStanceSoon:Schedule(57, 3)
		warnDefensiveStanceSoon:Schedule(58, 2)
		warnDefensiveStanceSoon:Schedule(59, 1)
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(143594))
			DBM.InfoFrame:Show(5, "function", updateInfoFrame, true)
		end
	elseif args.spellId == 143593 then
		if not allForcesReleased then
			defensiveActive = true
			self:RegisterShortTermEvents(
				"SWING_DAMAGE",
				"RANGE_DAMAGE",
				"SPELL_PERIODIC_DAMAGE"
			)
			table.wipe(dotWarned)
		end
		warnDefensiveStance:Show()
		specWarnDefensiveStance:Show()
		timerBattleStanceCD:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(143593))
			DBM.InfoFrame:Show(5, "function", updateInfoFrame, true)
		end
	elseif args.spellId == 143536 then
		warnKorkronBanner:Show()
		specWarnKorkronBanner:Show()
		if self.Options.SetIconOnAdds then
			self:ScanForMobs(71626, 2, 8, 1, 0.2, 4)--banner
		end
	elseif args.spellId == 143474 then
		warnHealingTideTotem:Show()
		specWarnHealingTideTotem:Show()
	elseif args.spellId == 143494 then--Because it can miss, we start CD here instead of APPLIED
		timerSunderCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 143494 then
		local amount = args.amount or 1
		warnSunder:Show(args.destName, amount)
		timerSunder:Start(args.destName)
		if args:IsPlayer() then
			if amount >= 4 then--At this point the other tank SHOULD be clear.
				specWarnSunder:Show(amount)
			end
		else--Taunt as soon as stacks are clear, regardless of stack count.
			if amount >= 3 and not UnitDebuff("player", sunder) and not UnitIsDeadOrGhost("player") then
				specWarnSunderOther:Show(args.destName)
			end
		end
	elseif args.spellId == 143484 then
		warnCoolingOff:Show(args.destName)
		timerCoolingOff:Start()
		countdownCoolingOff:Start()
	elseif args.spellId == 143480 then
		warnAssasinsMark:Show(args.destName)
		if args:IsPlayer() then
			specWarnAssassinsMark:Show()
			yellAssassinsMark:Yell()
		else
			specWarnAssassinsMarkOther:Show(args.destName)
		end
	elseif args.spellId == 143475 and not args:IsDestTypePlayer() then
		warnEarthShield:Show(args.destName)
		specWarnEarthShield:Show(args.destName)
	elseif args.spellId == 143638 then
		warnBonecracker:CombinedShow(1.5, args.destName)
		timerBoneCD:DelayedStart(1.5)--Takes a while to get on all targets. 1.5 seconds in 10 man, not sure about 25 man yet
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 143494 then
		timerSunder:Cancel(args.destName)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 71519 then--Kor'kron Warshaman
		timerEmpoweredChainHealCD:Cancel(args.destName, args.destGUID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.newForces1 or msg == L.newForces2 or msg == L.newForces3 or msg == L.newForces4 or msg == L.newForces5 then
		addsCount = addsCount + 1
		warnAdds:Show(addsCount)
		specWarnAdds:Show(addsCount)
		timerAddsCD:Start(nil, addsCount+1)
		countdownAdds:Start()
		if self.Options.SetIconOnAdds then
			self:ScanForMobs(addsTable, 2, 7, 4, 0.2, 10)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Show(5, "function", updateInfoFrame, true)
		end
	elseif msg == L.allForces then
		allForcesReleased = true
		defensiveActive = false
		self:UnregisterShortTermEvents()--Do not warn defensive stance below 10%
		--Icon setting not put here on purpose, so as not ot mess with existing adds (it's burn boss phase anyawys)
		specWarnAdds:Show(0)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 143500 then--Faster than combat log by 0.3-0.5 seconds
		self:BossTargetScanner(71515, "LeapTarget", 0.05, 16)
	end
end

function mod:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 143873 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then
		specWarnRavagerMove:Show()
	elseif sourceGUID == UnitGUID("player") and destGUID == UnitGUID("boss1") and self:AntiSpam(3, 1) then--If you've been in LFR at all, you'll see that even 3 is generous. 8 is WAY too leaniant.
		if not UnitDebuff("player", sunder) and defensiveActive then
			specWarnDefensiveStanceAttack:Show()
		end
	end
end
mod.RANGE_DAMAGE = mod.SPELL_DAMAGE
mod.SWING_DAMAGE = mod.SPELL_DAMAGE

function mod:SPELL_PERIODIC_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellId)--Prevent spam on DoT
	if sourceGUID == UnitGUID("player") and destGUID == UnitGUID("boss1") and self:AntiSpam(3, 1) then
		if not UnitDebuff("player", sunder) and defensiveActive and not dotWarned[spellId] then
			dotWarned[spellId] = true
			specWarnDefensiveStanceAttack:Show()
		end
	end
end
