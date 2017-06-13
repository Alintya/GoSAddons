local version = "1.0"


function SkinChangerPrint(msg)
	print("<font color=\"#00ffff\">SkinChanger:</font><font color=\"#ffffff\"> "..msg.."</font>")
end


http = require('socket.http')

if FileExist(COMMON_PATH.."json.lua") == false then
    SkinChangerPrint("json.lua missing, downloading to common.")
    DownloadFileAsync("https://raw.githubusercontent.com/craigmj/json4lua/master/json/json.lua",
    COMMON_PATH.."json.lua",
    function()
        SkinChangerPrint("Downloaded json.lua. Press 2x F6 to reload!") 
        return 
    end)

    return
end

json = require("json")

SkinChangerPrint("Loading TrulyBetter SkinChanger by Mystery69.")

-- Menu
local Menu = Menu("menu", myHero.charName .. " Skins")

local ddragon_version_response = http.request("https://ddragon.leagueoflegends.com/api/versions.json")
local ddragon_version = json.decode(ddragon_version_response)[0]
--SkinChangerPrint("DDragon version: "..ddragon_version)

local ddragon_skin_list = http.request("http://ddragon.leagueoflegends.com/cdn/" .. ddragon_version .. "/data/" .. "en_US" .. "/champion/" .. myHero.charName .. ".json")
--print("skinlist: ", ddragon_skin_list)

o = json.decode(ddragon_skin_list)

for k, v in pairs(o.data) do  
    skins = o.data[k].skins
end

local skin_names = {}
for i, skin in pairs(skins) do
    skin_names[i + 1] = skin.name
end

Menu:DropDown('skin', "Choose", 1, skin_names,
    function(selection)
        HeroSkinChanger(myHero, selection - 1)
        SkinChangerPrint("Loaded " .. skin_names[selection] .. "!") 
    end,
    true)

function AutoUpdate()
    local remoteVersion = GetWebResultAsync("https://raw.githubusercontent.com/Alintya/GoSAddons/master/TrulyBetter%20Skinchanger.version")
    if tonumber(remoteVersion) > tonumber(version) then
        SkinChangerPrint("Update" .. remoteVersion .. "found! (from " .. version .. ")")
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Alintya/GoSAddons/master/TrulyBetter%20SkinChanger.lua", SCRIPT_PATH .. "TrulyBetter SkinChanger.lua", 
            function() 
                PrintChat("Update Complete, press 2x F6 to reload!") 
                return 
            end)
    else
        SkinChangerPrint("We are on newest version!")
    end
end

SkinChangerPrint("TrulyBetter SkinChanger loaded!")