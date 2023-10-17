require "libs.timers"
chatPrefix = "{darkgreen} [LO3] "

WARMUP_TIME = true
warmupDelay = 0
scrambleDelay = 0
scrambleTime = 0

function HC_ReplaceColorCodes_pug(text)
	text = string.gsub(text, "{white}", "\x01")
	text = string.gsub(text, "{darkred}", "\x02")
	text = string.gsub(text, "{purple}", "\x03")
	text = string.gsub(text, "{darkgreen}", "\x04")
	text = string.gsub(text, "{lightgreen}", "\x05")
	text = string.gsub(text, "{green}", "\x06")
	text = string.gsub(text, "{red}", "\x07")
	text = string.gsub(text, "{lightgray}", "\x08")
	text = string.gsub(text, "{yellow}", "\x09")
	text = string.gsub(text, "{orange}", "\x10")
	text = string.gsub(text, "{darkgray}", "\x0A")
	text = string.gsub(text, "{blue}", "\x0B")
	text = string.gsub(text, "{darkblue}", "\x0C")
	text = string.gsub(text, "{gray}", "\x0D")
	text = string.gsub(text, "{darkpurple}", "\x0E")
	text = string.gsub(text, "{lightred}", "\x0F")
	return text
end

function HC_PrintChatAll_pug(text)		
	ScriptPrintMessageChatAll(" " .. HC_ReplaceColorCodes_pug(chatPrefix .. text))
end

function PrintHelp()
    HC_PrintChatAll_pug("{white}------------------------------------------------")
    HC_PrintChatAll_pug("{white}【ウォームアップ中】")
    HC_PrintChatAll_pug("{red}.lo3{white} : 試合を開始します。")
    HC_PrintChatAll_pug("{red}.restart{white} : ウォームアップをリスタートします。")
    HC_PrintChatAll_pug("{red}.scramble{white} : チームメンバーを3回シャッフルします。")
    HC_PrintChatAll_pug("{white}【試合中】")
    HC_PrintChatAll_pug("{red}.pause{white} : 試合をポーズ状態にします。")
    HC_PrintChatAll_pug("{red}.unpause{white} : 試合のポーズ状態を解除します。")
    HC_PrintChatAll_pug("{red}.forceend{white} : 試合を強制終了します。")
    HC_PrintChatAll_pug("{white}------------------------------------------------")
end

function PrintWaitingforPlayers(event)
    Timers:CreateTimer("warmup_timer", {
        callback = function()
            if (WARMUP_TIME == true) then
                if warmupDelay == 20 then
                    SendToServerConsole("bot_kick")
                    HC_PrintChatAll_pug("{white} ウォームアップ中、sv_cheatsは有効です。")
                    HC_PrintChatAll_pug("{white} 全員の準備が確認できたあと、")
                    HC_PrintChatAll_pug("{white} コンソールに {red}.lo3{white} とタイプして試合を開始します。")
                    HC_PrintChatAll_pug("{white} コンソールに {red}.help{white} とタイプしてヘルプを表示します。")
                    warmupDelay = 0
                else
                    warmupDelay = warmupDelay + 1
                end
            end
            return 1
        end,
    })
end

function StartWarmup()
    SendToServerConsole("mp_unpause_match")
    SendToServerConsole("bot_kick")
    SendToServerConsole("sv_cheats 1")
    SendToServerConsole("sv_grenade_trajectory_prac_pipreview 1")
    SendToServerConsole("sv_grenade_trajectory_prac_trailtime 4")
    SendToServerConsole("sv_infinite_ammo 2")
    SendToServerConsole("mp_buy_anywhere 1")
    SendToServerConsole("mp_warmuptime 234124235")
    SendToServerConsole("mp_warmuptime_all_players_connected 234124235")
    SendToServerConsole("mp_warmup_pausetimer 1")
	SendToServerConsole("mp_warmup_start")
    HC_PrintChatAll_pug("{white} ウォームアップ中、sv_cheatsは有効です。")
    HC_PrintChatAll_pug("{white} 全員の準備が確認できたあと、")
    HC_PrintChatAll_pug("{white} コンソールに {red}.lo3{white} とタイプして試合を開始します。")
    HC_PrintChatAll_pug("{white} コンソールに {red}.help{white} とタイプしてヘルプを表示します。")
    WARMUP_TIME = true
end

function StartPug()
    SendToServerConsole("bot_kick")
    SendToServerConsole("mp_warmup_start")
    SendToServerConsole("sv_grenade_trajectory_prac_pipreview 0")
    SendToServerConsole("sv_grenade_trajectory_prac_trailtime 0")
    SendToServerConsole("sv_infinite_ammo 0")
    SendToServerConsole("mp_buy_anywhere 0")
    SendToServerConsole("sv_cheats 0")
    SendToServerConsole("mp_warmuptime 10")
    SendToServerConsole("mp_warmuptime_all_players_connected 10")
    SendToServerConsole("mp_warmup_pausetimer 0")
    HC_PrintChatAll_pug("{white} 10秒後に試合が開始されます。")
    HC_PrintChatAll_pug("{white} 10秒後に試合が開始されます。")
    HC_PrintChatAll_pug("{white} 10秒後に試合が開始されます。")
    WARMUP_TIME = false
end	

function ScrambleTeams()
    scrambleTime = 2
    HC_PrintChatAll_pug("{white} チームメンバーがあと3回シャッフルされます。")
    SendToServerConsole("mp_scrambleteams")
    Timers:CreateTimer("scramble_timer", {
        callback = function()
            if scrambleDelay == 1 then
                HC_PrintChatAll_pug("{white} チームメンバーがあと"..scrambleTime.."回シャッフルされます。")
                SendToServerConsole("mp_scrambleteams")
                scrambleTime = scrambleTime - 1
                scrambleDelay = 0
            else
                scrambleDelay = scrambleDelay + 1
            end
            if scrambleTime == 0 then
                Timers:RemoveTimer(scramble_timer)
            end
            return 1
        end,
    })
end

Convars:RegisterCommand(".lo3", function() 
	local user = Convars:GetCommandClient()
	
	if (WARMUP_TIME == true) then
		StartPug()
	end
end, nil, 0)

Convars:RegisterCommand(".help", function() 
	local user = Convars:GetCommandClient()
	PrintHelp()
end, nil, 0)

Convars:RegisterCommand(".forceend", function()
	local user = Convars:GetCommandClient()
    if (WARMUP_TIME == false) then
        HC_PrintChatAll_pug("{red} 試合が中止されました。")
        StartWarmup()
    end
end, nil, 0)

Convars:RegisterCommand(".scramble", function()
	local user = Convars:GetCommandClient()

	if (WARMUP_TIME == true) then
        ScrambleTeams()
    end
end, nil, 0)

Convars:RegisterCommand(".pause", function()
	local user = Convars:GetCommandClient()
	
    SendToServerConsole("mp_pause_match")
    HC_PrintChatAll_pug("{white} 試合がポーズ状態になります。")
end, nil, 0)

Convars:RegisterCommand(".unpause", function()
	local user = Convars:GetCommandClient()
    HC_PrintChatAll_pug("{white} 試合のポーズ状態が解除されます。")
    SendToServerConsole("mp_unpause_match")
end, nil, 0)

function OnPlayerSpawned(event)
	PrintWaitingforPlayers(event)
end

StartWarmup()

ListenToGameEvent("player_spawn", OnPlayerSpawned, nil)

print("[LO3] Plugin loaded!")