-- Global Variables
DPSMate.Options.CurMode = "damage"

-- Local Variables
local LastPopUp = GetTime()
local TimeToNextPopUp = 300
local PartyNum = GetNumPartyMembers()
local Dewdrop = AceLibrary("Dewdrop-2.0")
local graph = AceLibrary("Graph-1.0")
local Options = {
	[1] = {
		type = 'group',
		args = {
			dps = {
				order = 10,
				type = 'toggle',
				name = "DPS",
				desc = DPSMate.localization.desc.dps,
				get = function() return DPSMateSettings["options"][1]["dps"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dps") end,
			},
			damage = {
				order = 20,
				type = 'toggle',
				name = "Damage",
				desc = DPSMate.localization.desc.damage,
				get = function() return DPSMateSettings["options"][1]["damage"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damage") end,
			},
			damagetaken = {
				order = 30,
				type = 'toggle',
				name = "Damage taken",
				desc = DPSMate.localization.desc.damagetaken,
				get = function() return DPSMateSettings["options"][1]["damagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "damagetaken") end,
			},
			enemydamagedone = {
				order = 40,
				type = 'toggle',
				name = "Enemy damage done",
				desc = DPSMate.localization.desc.enemydmgdone,
				get = function() return DPSMateSettings["options"][1]["enemydamagedone"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagedone") end,
			},
			enemydamagetaken = {
				order = 50,
				type = 'toggle',
				name = "Enemy damage taken",
				desc = DPSMate.localization.desc.enemydmgtaken,
				get = function() return DPSMateSettings["options"][1]["enemydamagetaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "enemydamagetaken") end,
			},
			healing = {
				order = 60,
				type = 'toggle',
				name = "Healing",
				desc = DPSMate.localization.desc.healing,
				get = function() return DPSMateSettings["options"][1]["healing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healing") end,
			},
			healingandabsorbs = {
				order = 70,
				type = 'toggle',
				name = "Healing and Absorbs",
				desc = DPSMate.localization.desc.healingandabsorbs,
				get = function() return DPSMateSettings["options"][1]["healingandabsorbs"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingandabsorbs") end,
			},
			healingtaken = {
				order = 80,
				type = 'toggle',
				name = "Healing taken",
				desc = DPSMate.localization.desc.healingtaken,
				get = function() return DPSMateSettings["options"][1]["healingtaken"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "healingtaken") end,
			},
			overhealing = {
				order = 90,
				type = 'toggle',
				name = "Overhealing",
				desc = DPSMate.localization.desc.overhealing,
				get = function() return DPSMateSettings["options"][1]["overhealing"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "overhealing") end,
			},
			interrupts = {
				order = 100,
				type = 'toggle',
				name = "Interrupts",
				desc = DPSMate.localization.desc.interrupts,
				get = function() return DPSMateSettings["options"][1]["interrupts"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "interrupts") end,
			},
			deaths = {
				order = 110,
				type = 'toggle',
				name = "Deaths",
				desc = DPSMate.localization.desc.deaths,
				get = function() return DPSMateSettings["options"][1]["deaths"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "deaths") end,
			},
			dispels = {
				order = 120,
				type = 'toggle',
				name = "Dispels",
				desc = DPSMate.localization.desc.dispels,
				get = function() return DPSMateSettings["options"][1]["dispels"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(1, "dispels") end,
			},
		},
		handler = DPSMate.Options,
	},
	[2] = {
		type = 'group',
		args = {
			total = {
				order = 10,
				type = 'toggle',
				name = "Total",
				desc = DPSMate.localization.desc.total,
				get = function() return DPSMateSettings["options"][2]["total"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "total") end,
			},
			currentFight = {
				order = 20,
				type = 'toggle',
				name = "Current fight",
				desc = DPSMate.localization.desc.current,
				get = function() return DPSMateSettings["options"][2]["currentfight"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight") end,
			},
		},
		handler = DPSMate.Options,
	},
	[3] = {
		type = 'group',
		args = {
			report = {
				order = 10,
				type = 'execute',
				name = "Report",
				desc = DPSMate.localization.desc.report,
				func = "PopUpAccept",
			},
			reset = {
				order = 11,
				type = 'execute',
				name = "Reset",
				desc = DPSMate.localization.desc.reset,
				func = "PopUpAccept",
			},
			blank1 = {
				order = 20,
				type = 'header',
			},
			startnewsegment = {
				order = 25,
				type = 'execute',
				name = "Start new segment",
				desc = DPSMate.localization.desc.newsegment,
				func = function() DPSMate.Options:NewSegment(); Dewdrop:Close() end,
			},
			deletesegment = {
				order = 30,
				type = 'group',
				name = "Remove segment",
				desc = DPSMate.localization.desc.removesegment,
				args = {
					sub1 = {
						type = "execute",
						name = "Test 1",
						desc = "Test 1 desc",
						func = "PopUpAccept",
					}, 
					sub2 = {
						type = "execute",
						name = "Test 2",
						desc = "Test 2 desc",
						func = "PopUpAccept",
					},
				},
			},
			blank2 = {
				order = 35,
				type = 'header',
			},
			lock = {
				order = 40,
				type = 'toggle',
				name = "Lock window",
				desc = DPSMate.localization.desc.lock,
				get = function() return DPSMateSettings["options"][3]["lock"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(3, "lock") end,
			},
			hide = {
				order = 50,
				type = 'execute',
				name = "Hide window",
				desc = DPSMate.localization.desc.hide,
				func = "PopUpAccept",
			},
			configure = {
				order = 80,
				type = 'execute',
				name = "Configure",
				desc = DPSMate.localization.desc.config,
				func = "PopUpAccept",
			},
			close = {
				order = 90,
				type = 'execute',
				name = "Close",
				desc = DPSMate.localization.desc.close,
				func = "PopUpAccept",
			},
		},
		handler = DPSMate.Options,
	},
}
local DetailsUser = ""
local DetailsSelected = 1
local DetailsArr, DetailsTotal
local PieChart = true
local g, g2

-- Begin Functions

function DPSMate.Options:OnEvent(event)
	if event == "PARTY_MEMBERS_CHANGED" and DPSMate.Options:IsInParty() and DPSMate.Options:PartyMemberAmountChanged() then
		if (GetTime()-LastPopUp) > TimeToNextPopUp and (DPSMateUser ~= {} and DPSMateUserCurrent ~= {}) then -- To prevent spam
			LastPopUp = GetTime()
			DPSMate_PopUp:Show()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if (DPSMateUser ~= {} and DPSMateUserCurrent ~= {}) then
			DPSMate_PopUp:Show()
		end
	end
end

function DPSMate.Options:IsInParty()
	if GetNumPartyMembers() > 0 or UnitInRaid("player") then
		return true
	else
		PartyNum = GetNumPartyMembers()
		return false
	end
end

function DPSMate.Options:PartyMemberAmountChanged()
	if GetNumPartyMembers() ~= PartyNum then
		PartyNum = GetNumPartyMembers()
		return true
	else
		return false
	end
end

function DPSMate.Options:PopUpAccept()
	DPSMate_PopUp:Hide()
	DPSMateUser = {}
	DPSMateUserCurrent = {}
	DPSMateHistory = {}
	DPSMateCombatTime = {
		total = 1,
		current = 1,
		segments = {},
	}
	DPSMate:HideStatusBars()
end

function DPSMate.Options:OpenMenu(b)
	if Dewdrop:IsOpen(DPSMate_Statusframe) then
		Dewdrop:Close()
		return
	end
	if Dewdrop:IsRegistered(DPSMate_Statusframe) then Dewdrop:Unregister(DPSMate_Statusframe) end
	Dewdrop:Register(DPSMate_Statusframe,
		'children', function() 
			Dewdrop:FeedAceOptionsTable(Options[b]) 
		end,
		'cursorX', true,
		'cursorY', true,
		'dontHook', true
	)
	Dewdrop:Open(DPSMate_Statusframe)
end

function DPSMate.Options:ToggleDrewDrop(i, obj)
	for cat, _ in pairs(DPSMateSettings["options"][i]) do
		DPSMateSettings["options"][i][cat] = false
	end
	DPSMateSettings["options"][i][obj] = true
	if i == 1 then
		DPSMate_Statusframe_Head_Font:SetText(Options[i]["args"][obj].name)
		DPSMate.Options.CurMode = obj
	elseif i == 2 then
	elseif i == 3 then end
	Dewdrop:Close()
	DPSMate:SetStatusBarValue()
	return true
end

function DPSMate.Options:ScrollFrame_Update()
	local line, lineplusoffset
	local obj = getglobal("DPSMate_Details_Log_ScrollFrame")
	local arr = DPSMate:GetMode()
	local user, pet = "",0
	DetailsArr, DetailsTotal = DPSMate.Options:EvalTable(DetailsUser)
	FauxScrollFrame_Update(obj,DPSMate:TableLength(DetailsArr),4,24)
	for line=1,4 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(obj)
		if DetailsArr[lineplusoffset] ~= nil then
			if (arr[DetailsUser][DetailsArr[lineplusoffset]]) then user=DetailsUser;pet=0; else user=arr[DetailsUser].pet;pet=5; end
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Name"):SetText(DetailsArr[lineplusoffset])
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_Value"):SetText(arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].amount.." ("..string.format("%.2f", (arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].amount*100/DetailsTotal)).."%)")
			getglobal("DPSMate_Details_Log_ScrollButton"..line):Show()
		else
			getglobal("DPSMate_Details_Log_ScrollButton"..line):Hide()
		end
		getglobal("DPSMate_Details_Log_ScrollButton"..line.."_selected"):Hide()
		if DetailsSelected == lineplusoffset then
			getglobal("DPSMate_Details_Log_ScrollButton"..line.."_selected"):Show()
		end
	end
end

function DPSMate.Options:EvalTable(t)
	local a, u, p = {}, {}, {}
	local total, pet = 0, ""
	local arr = DPSMate:GetMode()
	if (arr[t].pet and arr[t].pet ~= "Unknown") then u={a=t, b=arr[t].pet} else u={a=t} end
	for c, v in pairs(u) do
		for cat, val in pairs(arr[v]) do
			if (type(val) == "table" and cat~="dmgTime") then
				if (arr[v].isPet) then pet="(Pet)"; else pet=""; end
				local i = 1
				while true do
					if (not a[i]) then
						table.insert(a, i, cat..pet)
						p[cat..pet] = arr[v][cat].amount
						break
					else
						if (p[a[i]] < val.amount) then
							table.insert(a, i, cat..pet)
							p[cat..pet] = arr[v][cat].amount
							break
						end
					end
					i = i + 1
				end
			end
		end
		total=total+arr[v].damage
	end
	return a, total
end

function DPSMate.Options:SelectDetailsButton(i)
	local obj = getglobal("DPSMate_Details_Log_ScrollFrame")
	local lineplusoffset = i + FauxScrollFrame_GetOffset(obj)
	local arr = DPSMate:GetMode()
	local user, pet = "", 0
	DetailsSelected = lineplusoffset
	for p=1, 4 do
		getglobal("DPSMate_Details_Log_ScrollButton"..p.."_selected"):Hide()
	end
	if (arr[DetailsUser][DetailsArr[lineplusoffset]]) then user=DetailsUser; pet=0; else user=arr[DetailsUser].pet; pet=5; end
	getglobal("DPSMate_Details_Log_ScrollButton"..i.."_selected"):Show()
	getglobal("DPSMate_Details_LogDetails_Hit"):SetText("Hit: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].hit)
	getglobal("DPSMate_Details_LogDetails_HitMax"):SetText("HitMax: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].hithigh)
	getglobal("DPSMate_Details_LogDetails_HitMin"):SetText("HitMin: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].hitlow)
	getglobal("DPSMate_Details_LogDetails_Crit"):SetText("Crit: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].crit)
	getglobal("DPSMate_Details_LogDetails_CritMax"):SetText("CritMax: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].crithigh)
	getglobal("DPSMate_Details_LogDetails_CritMin"):SetText("CritMin: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].critlow)
	getglobal("DPSMate_Details_LogDetails_Miss"):SetText("Miss: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].miss)
	getglobal("DPSMate_Details_LogDetails_Parry"):SetText("Parry: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].parry)
	getglobal("DPSMate_Details_LogDetails_Dodge"):SetText("Dodge: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].dodge)
	getglobal("DPSMate_Details_LogDetails_Resist"):SetText("Resist: "..arr[user][strsub(DetailsArr[lineplusoffset], 1, strlen(DetailsArr[lineplusoffset])-pet)].resist)
end

function DPSMate.Options:UpdatePie()
	local i = 1
	local arr = DPSMate:GetMode()
	local user,pet = "",0
	g:ResetPie()
	for cat, val in pairs(DetailsArr) do
		if (arr[DetailsUser][DetailsArr[i]]) then user=DetailsUser;pet=0; else user=arr[DetailsUser].pet;pet=5; end
		local percent = (arr[user][strsub(DetailsArr[i], 1, strlen(DetailsArr[i])-pet)].amount*100/DetailsTotal)
		g:AddPie(percent, 0)
		i = i + 1
	end
end

function DPSMate.Options:UpdateDetails(obj)
	DetailsUser = obj.user
	if (PieChart) then
		g=graph:CreateGraphPieChart("PieChart", DPSMate_Details_Diagram, "CENTER", "CENTER", 0, 0, 200, 200)
		g2=graph:CreateGraphLine("LineGraph",DPSMate_Details_DiagramLine,"CENTER","CENTER",0,0,470,135)
		PieChart = false
	end
	DPSMate_Details_Title:SetText("Combat details of "..obj.user)
	DPSMate_Details:Show()
	DPSMate.Options:ScrollFrame_Update()
	DPSMate.Options:SelectDetailsButton(1)
	DPSMate.Options:UpdatePie()
	DPSMate.Options:UpdateLineGraph()
end

function DPSMate.Options:UpdateLineGraph()
	local arr, cbt = DPSMate:GetMode()
	local sumTable = DPSMate.Options:GetSummarizedTable()
	local max = DPSMate.Options:GetMaxLineVal(sumTable)
	
	g2:ResetData()
	g2:SetXAxis(0,cbt)
	g2:SetYAxis(0,max+200)
	g2:SetGridSpacing(cbt/10,max/7)
	g2:SetGridColor({0.5,0.5,0.5,0.5})
	g2:SetAxisDrawing(true,true)
	g2:SetAxisColor({1.0,1.0,1.0,1.0})
	g2:SetAutoScale(true)
	g2:SetYLabels(true, false)
	g2:SetXLabels(true)

	local Data1={{0,0}}
	for cat, val in pairs(DPSMate.Options:SortLineTable(sumTable)) do
		table.insert(Data1, {val[1],val[2]})
	end

	g2:AddDataSeries(Data1,{1.0,0.0,0.0,0.8})
end

function DPSMate.Options:GetSummarizedTable()
	local arr,_ = DPSMate:GetMode()
	local newArr, lastCBT, x, y, lastCBTVal = {}, 0, 0, 0, {}
	
	for cat, val in pairs(arr[DetailsUser]["dmgTime"]) do
		if (cat>=(lastCBT-0.05) and cat<=(lastCBT+0.05)) then
			local key = DPSMate:GetKeyByValInTT(newArr, x, y)
			y = newArr[key][2]+val
			table.remove(newArr, key)
			table.insert(newArr, {lastCBT,y})
		else
			x=tonumber(string.format("%.1f", cat))
			y=val
			table.insert(newArr, {x, y})
			lastCBT=x
			lastCBTVal={x,y}
		end
	end
	
	return newArr
end

function DPSMate.Options:SortLineTable(t)
	local newArr, minVal = {}, 10000000
	for cat, val in pairs(t) do
		if val[1]<minVal then
			table.insert(newArr, 1, val)
			minVal=val[1]
		else
			local i=1
			while true do
				if (not newArr[i]) then 
					table.insert(newArr, i, val)
					break
				end
				if val[1]<newArr[i][1] then
					table.insert(newArr, i, val)
					break
				end
				i=i+1
			end
		end
	end
	return newArr
end

function DPSMate.Options:GetMaxLineVal(t)
	local max = 0
	for cat, val in pairs(t) do
		if val[2]>max then
			max=val[2]
		end
	end
	return max
end

function DPSMate.Options:ChannelDropDown()
	local channel, i = {[1]="Whisper",[2]="Raid",[3]="Party",[4]="Say",[5]="Officer",[6]="Guild"}, 1
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Report_Channel, this.value)
    end
	
	-- Adding dynamic channel
	while true do
		local id, name = GetChannelName(i);
		if (not name) then break end
		table.insert(channel, name)
		i=i+1
	end
	
	-- Initializing channel
	for cat, val in pairs(channel) do
		UIDropDownMenu_AddButton{
			text = val,
			value = val,
			func = on_click,
		}
	end
	
	UIDropDownMenu_SetSelectedValue(DPSMate_Report_Channel, "Raid")
end

function DPSMate.Options:Report()
	local channel = UIDropDownMenu_GetSelectedValue(DPSMate_Report_Channel)
	local chn, index, sortedTable, total, a = nil, nil, DPSMate:GetSortedTable(DPSMate:GetMode())
	if (channel == "Whisper") then
		chn = "WHISPER"; index = DPSMate_Report_Editbox:GetText();
	elseif DPSMate:TContains({[1]="Raid",[2]="Party",[3]="Say",[4]="Officer",[5]="Guild"}, channel) then
		chn = channel
	else
		chn = "CHANNEL"; index = GetChannelName(channel)
	end
	SendChatMessage("DPSMate - "..DPSMate.localization.reportfor..DPSMate:GetModeName(), chn, nil, index)
	for i=1, DPSMate_Report_Lines:GetValue() do
		if (not sortedTable[i]) then break end
		SendChatMessage(i..". "..a[sortedTable[i]].." ................... "..sortedTable[i].." ("..string.format("%.1f", 100*sortedTable[i]/total).."%)", chn, nil, index)
	end
	DPSMate_Report:Hide()
end

function DPSMate.Options:NewSegment()
	if DPSMateUserCurrent ~= {} then
		table.insert(DPSMateHistory, 1, DPSMateUserCurrent)
		table.insert(DPSMateCombatTime["segments"], 1, DPSMateCombatTime["current"])
		if DPSMate:TableLength(DPSMateHistory)>5 then
			table.remove(DPSMateHistory, 6)
		end
		if DPSMate:TableLength(DPSMateCombatTime["segments"])>5 then
			table.remove(DPSMateCombatTime["segments"], 6)
		end
		DPSMateUserCurrent = {}
		DPSMateCombatTime["current"] = 1
		DPSMate:SetStatusBarValue()
	end
	DPSMate.Options:InitializeSegments()
end

function DPSMate.Options:InitializeSegments()
	local i=1
	for cat, val in pairs(DPSMateHistory) do
		Options[2]["args"]["segment"..i] = {
			order = 20+i*10,
			type = 'toggle',
			name = "Segment "..i,
			desc = "Fight deatails for segment "..i,
			get = "DropDownGetSegment"..i,
			set = "DropDownSetSegment"..i,
		}
		i=i+1
	end
end

function DPSMate.Options:DropDownGetSegment1()
	return DPSMateSettings["options"][2]["segment1"]
end
function DPSMate.Options:DropDownGetSegment2()
	return DPSMateSettings["options"][2]["segment2"]
end
function DPSMate.Options:DropDownGetSegment3()
	return DPSMateSettings["options"][2]["segment3"]
end
function DPSMate.Options:DropDownGetSegment4()
	return DPSMateSettings["options"][2]["segment4"]
end
function DPSMate.Options:DropDownGetSegment5()
	return DPSMateSettings["options"][2]["segment5"]
end

function DPSMate.Options:DropDownSetSegment1()
	DPSMate.Options:ToggleDrewDrop(2, "segment1")
end
function DPSMate.Options:DropDownSetSegment2()
	DPSMate.Options:ToggleDrewDrop(2, "segment2")
end
function DPSMate.Options:DropDownSetSegment3()
	DPSMate.Options:ToggleDrewDrop(2, "segment3")
end
function DPSMate.Options:DropDownSetSegment4()
	DPSMate.Options:ToggleDrewDrop(2, "segment4")
end
function DPSMate.Options:DropDownSetSegment5()
	DPSMate.Options:ToggleDrewDrop(2, "segment5")
end