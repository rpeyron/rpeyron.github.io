---
post_id: 5300
title: 'Une multiprise Sonoff Basic sous Tasmota allumée avec le PC'
date: '2021-02-14T21:58:31+01:00'
last_modified_at: '2021-03-20T14:34:02+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5300'
slug: une-multiprise-sonoff-basic-sous-tasmota-allumee-avec-le-pc
permalink: /2021/02/une-multiprise-sonoff-basic-sous-tasmota-allumee-avec-le-pc/
image: /files/20210214_172325.jpg
categories:
    - Domotique
tags:
    - PC
    - Prise
    - Tasmota
    - USB
    - autohotkey
lang: fr
featured: 185
---

Avec le télétravail mon espace PC s’est étoffé de nombreux périphériques pour améliorer les conditions de travail : clavier, souris, écran, hauts parleurs, micro, imprimante, carte Wifi ac, et même avec l’hiver un tapis de souris chauffant! Tout ce petit monde se branche en USB sur plusieurs hubs USB en cascade, et branché sur un seul câble USB pour faciliter la bascule entre mon portable perso et le portable pro. Mais tout ce petit monde consomme pas mal, bien trop pour un seul port USB théoriquement limité à 500 mA. Un de mes hubs permet une alimentation externe pour pallier ce problème. Mais si je le branche simplement sur le secteur, il va rester allumé 24/24h et certains appareils vont se retrouver à être allumés et consommer inutilement. L’avantage du port USB du portable est qu’il est sous tension uniquement lorsque l’ordinateur est allumé.

L’objectif de ce projet de multiprise connectée est donc de singer ce comportement et d’être allumée seulement lorsque l’ordinateur est allumé. Cela permettra de brancher dessus non seulement l’alimentation externe du hub USB, mais aussi l’alimentation du PC, de l’écran, de l’imprimante, etc. Compte tenu de l’exiguité de l’emplacement où cela va être installé, j’ai choisi de sacrifier une multiprise et d’y ajouter un Sonoff Basic (acheté en promo sur Banggood pour moins de 5€), mais le principe peut fonctionner avec un peu n’importe quelle prise connectée compatible Tasmota, dont les Sonoff S20.

![](/files/20210130_202300.jpg){: .img-center .mw60}

# Partie matérielle – préparer le Sonoff Basic

La première chose à faire est d’installer Tasmota sur le Sonoff. Si vous avez une version “DIY”, l’installation peut se faire [intégralement en OTA sans souder](https://tasmota.github.io/docs/Sonoff-DIY/). Dans mon cas j’avais une version précédente, et je ne peux pas non plus me retenir de profiter des extensions possibles et d’ajouter un capteur en plus. En l’occurrence j’ai choisi un capteur BPM280, branché en I2C et qui permet de remonter la température et la pression.

On peut souder le BMP280 sur les emplacements pour la connexion série et relier 3V3, GND, et SCL sur TX et SDA sur RX (ou inversement, on aura la possibilité de paramétrer ça par la suite). J’ai mis suffisamment de longueur de cable pour pouvoir sortir le capteur du boitier au besoin, mais suffisamment peu pour qu’il soit contenu dans le boitier par défaut. Il faut savoir que le Sonoff Basic chauffe un peu, donc les mesures de températures ne seront pas très exactes. Vous pouvez percer des petits trous pour aérer un peu, ou plus simplement sortir le capteur du boitier. Pour ma part, comme c’est surtout la pression qui m’intéresse, j’ai tout laissé à l’intérieur.

![](/files/20210130_210113-300x160.jpg) ![](/files/20210130_212318-300x249.jpg) ![](/files/20210130_210057-300x170.jpg)
{: .center}

Ensuite avec l’aide un connecteur FTDI réglé en 3.3V et connecté sur ces mêmes bornes 3V3, TX, RX, GND, il faut uploader le firmware Tasmota et configurer le Wifi avec [Tasmotizer](https://github.com/tasmota/tasmotizer). Si vous avez opté comme moi pour le BMP280 il est nécessaire d’utiliser le firmware **tasmota-sensors.bin** pour avoir le support de ce capteur. Sinon, prenez le firmware standard. Si vous avez besoin de plus d’explications sur cette partie, vous pouvez consulter [mon précédent article sur le Sonoff Basic](/2019/12/sonoff-basic-sous-domoticz-avec-tasmota/), ou [la documentation de Tasmota](https://tasmota.github.io/docs/devices/Sonoff-Basic/) qui est très bien faite.

Selon vos besoins, vous pouvez aussi prévoir de déporter le bouton du Sonoff Basic en soudant simplement un bouton poussoir avec un câble directement sur les bornes du poussoir actuel. Si vous souhaitez un interrupteur (qui garde la position, contrairement à un poussoir), vous pouvez utiliser un des GPIOs disponibles et un peu plus de configuration pour que le bouton réponde comme vous le souhaitez. Attention à GPIO2 sur le Sonoff Basic R2 qui nécessite une résistance supplémentaire en IO2 et utiliser le 3V3 pour éviter que le signal soit bas au démarrage, ce qui empecherait le sonoff de booter. Vous pourriez aussi vouloir asservir ce bouton à la présence d’une tension sur port USB (en n’oubliant pas de décoreller les tensions avec par exemple un optocoupleur), ce qui serait l’émulation absolument parfaite du comportement souhaité. Pour mon cas, comme je souhaite alimenter le hub USB par cette prise, ça s’auto-alimenterait et ne s’éteindrait pas.

Il reste à raccorder le Sonoff à la multiprise. Comme vous le constatez, le sonoff ne traite que les fils de phase et neutre. Il faut donc faire attention à bien conserver le fil de terre (qui peut trouver sa place à l’intérieur du boitier moyennant quelques contorsions. Coupez l’alimentation de la multiprise aux dimensions du Sonoff en conservant le fil de terre (jaune et vert), dénudez les extrémités des fils, et les connecter dans le Sonoff. Attention à ne pas se tromper de sens en connectant les fils, la prise doit être du côté “Input” et la multiprise coté “Output” (ça peut paraitre évident mais j’ai perdu un temps fou avec cette inattention…).

![](/files/20210130_202837-300x137.jpg) ![](/files/20210130_213806-300x138.jpg) ![](/files/20210131_220934-300x155.jpg) ![](/files/20210130_214310-300x212.jpg)
{: .center}

Pour pouvoir passer le fil neutre dans le boitier sans le couper j’ai coupé les deux cotés du boitier Sonoff, c’est discret et ne remet en rien en cause la solidité du boitier une fois les serre-câbles vissés. Résultat une fois monté :

![](/files/20210214_172325-1024x576.jpg){: .img-center}

Pour pouvoir actionner l’interrupteur avec le pied sans avoir trop à viser ni risquer de le casser si le système automatique déraille, j’ai ajouté une petite coque imprimée en 3D ([STL disponible sur thingiverse](https://www.thingiverse.com/thing:4762266))

Pour finaliser la configuration du Sonoff, dans l’interface web du Sonoff, il faut configurer le module via Configuration / Configure Module pour indiquer les GPIO sur lesquels sont branchés les broches I2C SCL et SDA. Une fois renseignés Tasmota détectera automatiquement le capteur connecté et affichera les mesures correspondantes. Si cela ne marche pas, n’hésitez pas à inverser le paramétrage des deux broches…

![](/files/Sonoff_I2C_BMP280-252x300.png) ![](/files/Sonoff_I2C_BMP280_Display-300x201.png) ![](/files/Sonoff_I2C_BMP280_Domoticz-300x237.png)
{: .center}

Si vous avez Domoticz vous pouvez également déclarer un deuxième capteur virtuel pour récupérer les mesures sous Domoticz (voir [mon précédent article sur le Sonoff Basic](/2019/12/sonoff-basic-sous-domoticz-avec-tasmota/) pour plus d’informations sur le paramétrage MQTT et Domoticz). À noter que Domoticz ne proposant pas de capteur Temp et Baro uniquement il vous faudra utiliser Temp,Hum,Baro même si la mesure d’humidité sera toujours nulle. Par ailleurs, la température et la pression seront affichés via deux widgets séparés, le premier dans l’onglet Température et le second dans l’onglet Météo.

# Partie logicielle – option avec AutoHotKey

Il y a plein d’options possibles pour commander votre nouvelle mutiprise sous Tasmota. La première possibilité que j’ai choisie est d’utiliser [AutoHotKey](http://autohotkey.com) pour allumer la prise quand l’ordinateur s’allume, et l’éteindre quand l’ordinateur s’éteint. Pour permettre d’utiliser cette méthode sans aucun autre système domotique (ni MQTT, ni Domoticz, ni…), le script AutoHotKey va s’adresser directement au serveur web Tasmota via son adresse IP (dans la suite de l’article, j’utiliserai 192.168.0.44, à remplacer par l’adresse du Tasmota de votre multiprise).

Voici le script AutoHotKey :

```
#Persistent
#SingleInstance force

reg_key := "HKEY_CURRENT_USER\Software\PowerControl"

RegRead, IP, %reg_key%, IP
If ErrorLevel
	MsgBox, Please set up IP address in the parameters
IP := Trim(IP, " `t`n`r")

RegRead, pulse, %reg_key%, Pulse
If ErrorLevel
	pulse := 60

; Setup script ---------------------------------------------

Menu, TRAY, Tip, Power Control
Menu, Tray, Add
Menu, Tray, Add, Power On, TasmotaPowerOn
Menu, Tray, Add, Power Off, TasmotaPowerOff
Menu, Tray, Add
;Menu, Tray, Add, Start Pulse, TasmotaStartPulse
;Menu, Tray, Add, Stop Pulse, TasmotaStopPulse
Menu, Tray, Add, Autostart, ToggleAutostart
Menu, Tray, Add, Set IP address, param_SetIPAddress
Menu, Tray, Add, Pulse Mode, TasmotaTogglePulse
Menu, Tray, Add, Set Pulse, param_SetPulse

UpdateAutostartMenu()

RegRead, pulseon, %reg_key%, PulseOn
If ErrorLevel {
	pulseon := 0
}
	
If (pulseon > 0) {
	Menu, Tray, Check, Pulse Mode
	TasmotaStartPulse()		
} else {
	TasmotaStopPulse()		
}

TasmotaPowerOn()

; <^>!p::TasmotaPowerOn()
; <^>!o::TasmotaPowerOff()

; Register suspend resume notifications and unregister on exit
h := DllCall("RegisterSuspendResumeNotification", Ptr, A_ScriptHwnd, UInt, 0, Ptr)
OnExit( "cb_OnExit" )

; Listen to the Windows power event "WM_POWERBROADCAST" (ID: 0x218):
OnMessage(0x218, "func_WM_POWERBROADCAST")

; MsgBox, Setup Ok

Return

; Tasmota Part -------------------------------------------

TasmotaCall_MsXml(action) {
	Global IP
	switch_cmd := "http://" IP "/cm?cmnd="
	req := ComObjCreate("Msxml2.XMLHTTP")
	req.open("GET", switch_cmd action, true)
	req.send()
}

TasmotaCall(action, do_not_wait) {
	Global IP
	retry := 20
	
	If StrLen(IP) < 5
		return
	
	switch_cmd := "http://" IP "/cm?cmnd="
	url := switch_cmd action
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	;~ WinHTTP.SetProxy(0)
	if (do_not_wait > 0)  {
		Try { 
			WinHTTP.Open("GET", switch_cmd action, 0)
			WinHTTP.Send()
		}
		Catch e{  
		}
	} 
	else {
		; Short loops to handle wake up when network is not ready
		Loop {
			Try { 
				Status := 0
				WinHTTP.SetTimeouts("1000", "1000", "1000", "1000")
				WinHTTP.Open("GET", url, 0)
				WinHTTP.Send()
				WinHTTP.WaitForResponse()
				Status := WinHTTP.Status
				; Result := WinHTTP.ResponseText
			}
			Catch e{  
				; MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra  "`nurl: "  url
			}
			if ( ( Status >= 200) and ( Status < 400)  ) 
				break
			retry := retry - 1
			if (retry = 0)  
				break
			Sleep, 1000
		}
	}
}

TasmotaPowerOn() {
	TasmotaCall("Power On", 0)
}

TasmotaPowerOff() {
	TasmotaCall("Power Off", 1)
}

TasmotaStartPulse() {
	Global pulse
	TasmotaCall("PulseTime1 " + (100 + pulse * 2), 0)
	SetTimer, TasmotaPowerOn, % ( pulse * 1000 )
}

TasmotaStopPulse() {
	SetTimer, TasmotaPowerOn, Off
	TasmotaCall("PulseTime1 0", 1)
}

TasmotaTogglePulse() {
	Global pulseon
	Global reg_key
	pulseon := ! pulseon
	RegWrite, REG_DWORD, %reg_key%, PulseOn, %pulseon%
	if pulseon
		TasmotaStartPulse()
	else
		TasmotaStopPulse()
	CheckUncheck := pulseon ? "Check" : "Uncheck"
	Menu, Tray, %CheckUncheck%, Pulse Mode
}


; Suspend / Resume part -------------------------------------------
; From https://autohotkey.com/board/topic/19984-running-commands-on-standby-hibernation-and-resume-events/

cb_OnExit(ExitReason, ExitCode) {
	Func("UnRegisterNotification").Bind(h)
	; Also unregister Tasmota and PowerOff
	TasmotaStopPulse()
	TasmotaPowerOff()
}

UnRegisterNotification(handle) {
    DllCall("UnregisterSuspendResumeNotification", Ptr, handle)
}

func_WM_POWERBROADCAST(wParam, lParam)
{
	Global pulseon
	
	; PBT_APMSUSPEND or PBT_APMSTANDBY? -> System will sleep
	If (wParam = 4 OR wParam = 5) {
		; MsgBox, Suspend
		TasmotaPowerOff()
		if ( pulseon ) {
			TasmotaStopPulse()
		}
	}
	
	; PBT_APMRESUMESUSPEND oder PBT_APMRESUMESTANDBY? -> System wakes up
	If (wParam = 7 OR wParam = 8) {
		; MsgBox, Resume
		TasmotaPowerOn()
		if ( pulseon )  {
			TasmotaStartPulse()
		}
	}
	Return
}

; Autostart ------------------------------------------------------

IsAutostart() {
	SplitPath, A_Scriptname, , , , OutNameNoExt 
	LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
	Return FileExist(LinkFile)
}

UpdateAutostartMenu() {
	CheckUncheck := IsAutostart() ? "Check" : "Uncheck"
	Menu, Tray, %CheckUncheck% , Autostart	
}

ToggleAutostart() {
	If ( IsAutostart() ) {
		RemoveAutostart()
	} Else {
		InstallAutostart()
	}
	UpdateAutostartMenu()
}

InstallAutostart() {
	SplitPath, A_Scriptname, , , , OutNameNoExt 
	LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
	IfNotExist, %LinkFile%    ; TODO replace with !FileExist function
	  FileCreateShortcut, %A_ScriptFullPath%, %LinkFile% 
	SetWorkingDir, %A_ScriptDir%
}

RemoveAutostart() {
	SplitPath, A_Scriptname, , , , OutNameNoExt 
	LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
	IfExist, %LinkFile% 
	  FileDelete, %LinkFile% 
	SetWorkingDir, %A_ScriptDir%
}

; Parameters 

param_SetIPAddress() {
	Global IP
	Global reg_key
	InputBox, IP, IP Address, Please enter IP address of your Tasmota device, , , , , , , , %IP%
	if !ErrorLevel
		RegWrite, REG_MULTI_SZ, %reg_key%, IP, %IP%
}

param_SetPulse() {
	Global Pulse
	Global reg_key
	InputBox, Pulse, Pulse, Please enter Pulse of your Tasmota device, , , , , , , , %Pulse%
	if !ErrorLevel
		RegWrite, REG_DWORD, %reg_key%, Pulse, %Pulse%
}

```

Vous pouvez également télécharger la version précompilée : [PowerControl](/files/PowerControl.zip) (à décompresser)

Il vous faudra paramétrer l’adresse IP de votre Tasmota (assurez vous que votre box assigne toujours la même adresse IP à votre prise, ce qui devrait être le cas des principales box récentes ; l’adresse sera susceptible de changer si la box est changée ou réinitialisée).

Il y a également une option pour que le script démarre automatiquement avec Windows (pour la version compilée uniquement ou si vous avez associé l’extension ahk avec AutoHotKey).

Est également proposé un mode “Pulse”. Il se peut que pour une raison ou une autre, votre ordinateur s’éteigne sans avoir pu envoyer l’ordre d’extinction à votre multiprise (plantage, perte de réseau…). S’il est impératif que la prise soit éteinte quand le PC n’est pas allumé alors le mode “Pulse” est fait pour cela. Il utilise une commande de Tasmota qui s’appelle “[PulseTime](https://tasmota.github.io/docs/Commands/)” et qui permet de spécifier le nombre de secondes au bout desquelles la prise va s’éteindre toute seule (`PulseTime1 220` pour éteindre au bout de 120s secondes). Ce qui est intéressant c’est qu’une commande `Power On` va permettre de remettre à zéro le compteur. Il suffit donc d’envoyer cette commande régulièrement avec une période plus basse que le timer pour garder la prise allumée. Losque le PC sera éteint, il n’enverra plus cette commande et la prise s’éteindra automatiquement.

# Partie logicielle – option avec Domoticz pour une Freebox

La méthode ci-dessus marche très bien, mais elle nécessite que le PC soit sur le même réseau que le Tasmota. Or sur mon PC pro je suis amené à utiliser un VPN qui rend inaccessible mon réseau local lorsqu’il est actif. Mais avec un système domotique il est possible de faire mieux. En l’occurrence je vais utiliser mon système [Domoticz](https://www.domoticz.com/) et comme je suis actuelle chez Free, je vais utiliser le plugin [PluginDomoticzFreeBox](https://github.com/supermat/PluginDomoticzFreebox) qui permet d’interroger l’API de la Freebox pour savoir quels sont les appareils actuellement connectés au réseau de la Freebox. Ce système est assez fiable et fonctionne même lorsque mon PC pro utilise son VPN.

Ce plugin s’utilise de manière très simple en suivant les [instructions données sur la page du plugin](https://github.com/supermat/PluginDomoticzFreebox) : il faut cloner le git dans le répertoire plugins/ de Domoticz, ajouter dans “Hardware” le plugin, changer l’adresse par défaut qui ne fonctionne plus dans les paramètres par “http://mafreebox.freebox.fr”, et dans les 30 secondes après la première utilisation du plugin, aller valider l’accès sur la freebox pour pouvoir récupérer le token et le copier dans les paramètres. Si vous avez raté les 30 secondes, vous pouvez faire “modifier” le plugin dans la page “Hardware” ce qui va permettre qu’il soit redémarré et qu’il enclenche une nouvelle procédure d’authentification.

Vous pouvez ensuite ajouter dans les paramètres une liste d’adresses MAC d’appareils dont il faut surveiller la présence.![](/files/Domoticz_Freebox_Hardware.png){: .img-center}

Le plugin va alors créer un device de type interrupteurs par adresse MAC paramétrée (avec le nom donné par la Freebox) et dont l’état reflétera la présence ou non de ces équipements sur le réseau.![](/files/Domoticz_Freebox_Devices.png){: .img-center}

Si vous n’avez pas de Freebox, pas de panique il existe beaucoup d’autres méthodes pour détecter la présence, soit listées sur [la page Presence Detection du wiki Domoticz](https://www.domoticz.com/wiki/Presence_detection) soit en cherchant dans le forum de Domoticz sur la détection par IP ou par adresse MAC (notamment via arpwatch ou arping)

On peut maintenant créer un script qui va allumer ou éteindre notre prise connectée selon l’état des PCs que vous voulez surveiller. Pour ce type de script on atteint clairement les limites de Blockly, et la documentation des scripts python étant vraiment défaillante, j’ai opté pour [dzVents](https://www.domoticz.com/wiki/DzVents:_next_generation_Lua_scripting), dérivé de lua, qui est censé être le système de script le meilleur pour Domoticz et qui a au moins une documentation bien plus étoffée.

Voici le script utilisé (Configuration / Plus d’options / Evenements / “+” / dzVents) :

```lua
return {
	on = {
		timer = {
			'every minutes',
		},
		devices = {
			'Freebox - Presence ****' , 
			'Freebox - Presence HP'
		}
	},

	execute = function(domoticz)
	    local switch_name = 'Basic2'
	    local pc_names = { 'Freebox - Presence ****' , 'Freebox - Presence HP' }
        local pcs = domoticz.devices().filter(pc_names)
        
	    switch = domoticz.devices(switch_name)
	    
	    -- Count devices that are on
	    local pc_num = pcs.reduce(function(acc, device)
                        if (device.state == 'On') then  acc = acc + 1  end
                        return acc -- always return the accumulator
                    end, 0)

	    if (switch.active) then
	        if (pc_num == 0) then  switch.switchOff()  end
        else
	        if (pc_num > 0) then  switch.switchOn()  end
	    end
       
	end
}

```

La valeur de switch\_name ‘Basic2’ est à remplacer par le nom du Tasmota de votre multiprise dans Domoticz, et les valeurs de pc\_names par les noms des équipements dont la présence allumera la prise.

Dans ce script j’ai fait le choix d’exécuter ce script toutes les minutes, ce qui me permet d’être sûr que l’état de la prise est remise correctement toutes les minutes, ce qui me permet de la combiner aussi aux scripts AutoHotKey ci-dessus qui seront plus réactifs à l’allumage, mais avec potentiellement quelques ratés, notamment si j’utilise les deux ordinateurs simultanéments, car contrairement au script, qui ne s’intéresse qu’à l’état du PC sur lequel il est installé, le script Domoticz va s’intéresser à l’état de l’ensemble des portables surveillés. Mais si vous n’utilisez pas d’autre script, vous pouvez simplement supprimer l’instruction timer pour ne garder que le déclenchement sur modification de l’état des devices.

Si vous utilisez le mode PulseTime il faudra déplacer la ligne “if (pc\_num &gt; 0) then switch.switchOn() end” en dehors de la branche else, pour qu’elle soit exécutée systématiquement à chaque minute.

Voici pour la méthode que j’ai utilisée, mais comme vous l’avez compris, il existe de multiples variantes pour pouvoir adapter le principe à votre besoin.