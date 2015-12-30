-- Global Variables
DPSMate.Modules.CurePoisonReceived = {}
DPSMate.Modules.CurePoisonReceived.Hist = "Dispels"
DPSMate.Options.Options[1]["args"]["poisoncurereceived"] = {
	order = 215,
	type = 'toggle',
	name = 'Poison cure received',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["poisoncurereceived"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "poisoncurereceived", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("poisoncurereceived", DPSMate.Modules.CurePoisonReceived)


function DPSMate.Modules.CurePoisonReceived:GetSortedTable(arr)
	local b, a, temp, total = {}, {}, {}, 0
	for cat, val in pairs(arr) do -- 3 Owner
		for ca, va in pairs(val) do -- 42 Ability
			if ca~="i" then
				for c, v in pairs(va) do -- 3 Target
					for ce, ve in pairs(v) do -- 10 Cured Ability
						if DPSMateAbility[DPSMate:GetAbilityById(ce)][2]=="Poison" then
							if temp[c] then temp[c]=temp[c]+ve else temp[c]=ve end
						end
					end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, val)
				table.insert(a, i, cat)
				break
			else
				if b[i] < val then
					table.insert(b, i, val)
					table.insert(a, i, cat)
					break
				end
			end
			i=i+1
		end
		total = total + val
	end
	return b, total, a
end

function DPSMate.Modules.CurePoisonReceived:EvalTable(user, k)
	local a, b, temp, total = {}, {}, {}, 0
	local arr = DPSMate:GetMode(k)
	for cat, val in pairs(arr) do -- 3 Owner
		temp[cat] = {
			[1] = 0,
			[2] = {},
			[3] = {},
		}
		for ca, va in pairs(val) do -- 42 Ability
			if ca~="i" then
				for c, v in pairs(va) do -- 3 Target
					if c==user[1] then
						for ce, ve in pairs(v) do -- 10 Cured Ability
							if DPSMateAbility[DPSMate:GetAbilityById(ce)][2]=="Poison" then
								temp[cat][1]=temp[cat][1]+ve
								local i = 1
								while true do
									if (not temp[cat][3][i]) then
										table.insert(temp[cat][3], i, ve)
										table.insert(temp[cat][2], i, ce)
										break
									else
										if temp[cat][3][i] < ve then
											table.insert(temp[cat][3], i, ve)
											table.insert(temp[cat][2], i, ce)
											break
										end
									end
									i=i+1
								end
							end
						end
						break
					end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, val)
				table.insert(a, i, cat)
				break
			else
				if b[i][1] < val[1] then
					table.insert(b, i, val)
					table.insert(a, i, cat)
					break
				end
			end
			i=i+1
		end
		total = total + val[1]
	end
	return a, total, b
end

function DPSMate.Modules.CurePoisonReceived:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.CurePoisonReceived:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		if DPSMateSettings["columnsdmg"][1] then str[1] = " "..dmg..p; strt[2] = tot..p end
		if DPSMateSettings["columnsdmg"][2] then str[2] = "("..string.format("%.1f", (dmg/cbt))..p..")"; strt[1] = "("..string.format("%.1f", (tot/cbt))..p..") " end
		if DPSMateSettings["columnsdmg"][3] then str[3] = " ("..string.format("%.1f", 100*dmg/tot).."%)" end
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[2]..str[1]..str[3])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.CurePoisonReceived:ShowTooltip(user,k)
	local a,b,c = DPSMate.Modules.CurePoisonReceived:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i][1],1,1,1,1,1,1)
			for p=1, 3 do 
				if not c[i][2][p] or c[i][3][p]==0 then break end
				GameTooltip:AddDoubleLine("       "..p..". "..DPSMate:GetAbilityById(c[i][2][p]),c[i][3][p],0.5,0.5,0.5,0.5,0.5,0.5)
			end
		end
	end
end


