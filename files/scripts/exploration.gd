
extends Node

var progress = 0.0
var enemygroup
var defeated = {}
var currentzone
var awareness = 0
var ambush = false
var scout
var launchonwin = null
var combatdata = load("res://files/scripts/combatdata.gd").new()

var enemygrouppools = combatdata.enemygrouppools
var capturespool = combatdata.capturespool
var enemypool = combatdata.enemypool


var zones = {

forest = {
background = 'crossroads',
combat = true,
code = 'forest',
name = 'Ancient Forest',
description = "You stand deep within this ancient forest. Giant trees tower above you, reaching into the skies and casting deep shadows on the ground below. As the wind whispers past, you can hear the movement of small creature in the undergrowth and birds singing from their perches above.",
enemies = [['thugseasy',10],['banditseasy', 20], ['peasant', 25],['solobear', 40], ['wolveseasy', 100]],
encounters = [['dolinforest','globals.state.sidequests.dolin == 0 || globals.state.sidequests.dolin == 5',10]],
length = 5,
exits = ['shaliq', 'wimbornoutskirts'],
races = [['Elf', 20], ['Beastkin Wolf',25],['Halfkin Bunny',30],['Beastkin Bunny',35],['Halfkin Wolf',40],['Human', 100]]
},

elvenforest = {
background = 'forest',
combat = true,
code = 'elvenforest',
name = 'Deep Elven Grove',
description = "This portion of the forest is located dangerously close to eleven lands. They take poorly to intruders in their part of the woods so you should remain on your guard.",
enemies = [['fairy',3],['thugseasy',10],['solobear', 15], ['peasantgroup', 20], ['peasant', 25],['elfguards',35],['banditseasy', 50],['plantseasy',65],['wolveseasy', 100]],
encounters = [],
length = 5,
exits = ['wimbornoutskirts'],
races = [['Dark Elf', 20],['Drow', 25],['Elf', 100]]
},

grove = {
background = 'grove',
combat = true,
code = 'grove',
name = 'Far Eerie Woods',
description = "This portion of the forest is deeply shadowed, and strange sounds drift in and out of hearing. Something about the atmosphere keeps the normal forest creatures silent, lending an eerie, mystic feeling to the grove you stand within.",
enemies = [['dryad',10], ['solobear', 15], ['fairy', 30],['wolveshard', 45],['plantseasy',80], ['wolveseasy', 100]],
encounters = [['dolingrove','globals.state.sidequests.dolin == 12',25],['snailevent','globals.state.farm >= 4 && globals.state.snails < 10',10]],
length = 5,
exits = ['wimbornoutskirts'],
races = [['Fairy', 60],["Dryad", 100]]
},

marsh = {
background = 'marsh',
combat = true,
code = 'marsh',
name = 'Marsh',
description = "Dank bog lies at the border of the forest and swamps beyond. Noxious smells and a sinister aura prevail throughout. The landscape itself is hostile, with pitch-black pools of water mixed among the solid ground and you doubt that the creatures that live here are any more pleasant than the land they live in.",
enemies = [['banditcamp',10],['monstergirl',20], ['oozesgroup',35], ['solospider',85], ['solobear', 100]],
encounters = [],
length = 5,
exits = ['frostfordoutskirts'],
races = [['Arachna', 15],['Lamia', 40],['Slime', 55],['Demon', 100]]
},

mountains = {
background = 'mountains',
combat = true,
code = 'mountains',
name = 'Mountains',
description = "You climb over small hills in search for any activity in these elevated grounds.",
enemies = [['slaversmedium',5],['harpy',15],['banditsmedium', 20],['travelersgroup', 35],['fewcougars',100]],
encounters = [],
length = 6,
exits = ['gornoutskirts'],
races = [['Dragonkin',3],['Seraph',8],['Gnome', 20],['Centaur',30],['Goblin', 70],['Orc',100]]
},

sea = {
background = 'sea',
combat = true,
code = 'sea',
name = 'Sea',
description = "You are at the beach of a Big Sea. Air smells of salt and you can spot some sea caves formed by plateau and incoming waves.",
enemies = [['banditcamp',10],['monstergirl', 35],['travelersgroup',50],['oozesgroup',100]],
encounters = [],
length = 5,
exits = ['gornoutskirts'],
races = [['Scylla', 40],['Lamia', 70],['Nereid', 100]]
},

shaliq = {
background = 'shaliq',
combat = false,
code = 'shaliq',
name = 'Shaliq Village',
description = "This small, rural village looks calm and peaceful. It seems many personal portals lead here and travelers are not rare sight for locals, as you barely get any attention.",
enemies = [],
encounters = [],
length = 0,
exits = ['shaliq']
},

wimbornoutskirts = {
background = 'meadows',
combat = false,
code = 'wimbornoutskirts',
name = 'Wimborn Outskirts',
description = "You walk out of Wimborn and get far away from its walls until road brings you to the intersection. From here you may choose what area you would like to scout. ",
enemies = [],
encounters = [],
length = 0,
exits = ['wimbornoutskirts']
},

wimbornoutskirtsexplore = {
background = 'meadows',
combat = true,
code = 'wimbornoutskirtsexplore',
name = 'Wimborn Outskirts',
description = "The town's outskirts look spacy and green. ",
enemies = [['banditsmedium',10],['slaverseasy',15],['peasant',20],['banditseasy',50],['thugseasy',65],['wolveseasy',100]],
encounters = [],
length = 5,
exits = ['wimbornoutskirts'],
races = [['Beastkin Cat', 5], ['Halfkin Cat', 10],['Beastkin Tanuki', 12], ['Halfkin Tanuki', 15],['Elf', 19],['Taurus',30],['Human', 100]]
},
wimborn = {
background = 'wimborn',
combat = false,
code = 'wimborn',
name = 'Wimborn',
description = "Though the weather is commonly hot, the streets are rich with many kinds of races. Orcs and goblins are the most prevalent citizens, and small traders can be seen virtually everywhere, however, you can still frequently notice some humans, gnomes and even centaurs among the bystanders. Rare Orc Guard Patrols keep their eyes out for any potential troublemakers. ",
enemies = [],
encounters = [],
length = 0,
exits = ['wimborn']
},
gorn = {
background = 'gorn',
combat = false,
code = 'gorn',
name = 'Gorn',
description = "Though the weather is commonly hot, the streets are rich with many kinds of races. Orcs and goblins are the most prevalent citizens, and small traders can be seen virtually everywhere, however, you can still frequently notice some humans, gnomes and even centaurs among the bystanders. Rare Orc Guard Patrols keep their eyes out for any potential troublemakers. ",
enemies = [],
encounters = [],
length = 0,
exits = ['gorn']
},

gornalchemist = {
background = 'gorn',
combat = false,
code = 'gornalchemist',
name = 'Alchemical Shop',
description = "",
enemies = [],
encounters = [],
length = 0,
exits = ['gornalchemist']
},

gornoutskirts = {
background = 'highlands',
combat = false,
code = 'gornoutskirts',
name = 'Gorn Outskirts',
description = "You walk out of Gorn and get far away from its walls until road brings you to the intersection. These arid areas lead to moutains and cave systems. You can feel sun getting hotter over your head.",
enemies = [],
encounters = [],
length = 0,
exits = ['gornoutskirts']
},

gornoutskirtsexplore = {
background = 'highlands',
combat = true,
code = 'gornoutskirtsexplore',
name = 'Gorn Outskirts',
description = "The town's outskirts look bright and green. ",
enemies = [['slaverseasy',10],['peasant',20],['banditseasy',60],['thugseasy',75],['wolveseasy', 100]],
encounters = [],
length = 5,
exits = ['gornoutskirts'],
races = [['Centaur',5],['Dark Elf', 15],['Goblin', 40],['Orc', 100]]
},

frostfordoutskirts = {
background = 'borealforest',
combat = false,
code = 'frostfordoutskirts',
name = 'Frostford Outskirts',
description = "Main road quickly branches off at thick boreal forest. Even though Frostford is considerably dense in population, its periphery is far less inhabitable due to harsh climat. ",
enemies = [],
encounters = [],
length = 0,
exits = ['frostfordoutskirts']
},

frostfordoutskirtsexplore = {
background = 'borealforest',
combat = true,
code = 'frostfordoutskirtsexplore',
name = 'Frostford Outskirts',
description = "You make your way through semi-utilized forest paths paying attention to the surroundings. ",
enemies = [['banditsmedium',10],['travelersgroup',25],['peasant',60],['thugseasy',75],['solobear', 100]],
encounters = [],
length = 5,
exits = ['frostfordoutskirts'],
races = [['Beastkin Wolf', 40],['Halfkin Fox', 45],['Beastkin Fox', 50],['Halfkin Cat', 55],['Beastkin Cat',65],['Halfkin Wolf', 75],['Beastkin Wolf', 85],['Human', 100]]
},

frostford = {
background = 'frostford',
combat = false,
code = 'frostford',
name = 'Frostford',
description =  "Despite this region being frequently covered in snow, it's not terribly cold here; it’s even warmer on the streets, perhaps thankfully to the density of the population.\n\n The roads are lively, with many beastkins and halfkins of different kinds strolling and talking to one another - despite the activity, the whole town has a very relaxed and calm atmosphere. ",
enemies = [],
encounters = [],
length = 0,
exits = ['frostford']
}
}

var buttoncontainer
var button
var newbutton
var main
var outside

func mansionreturn():
	main._on_mansion_pressed()

func event(eventname):
	globals.events.call(eventname)

func zoneenter(zone):
	zone = self.zones[zone]
	main.background_set(zone.background)
	if OS.get_name() != "HTML5" && globals.rules.fadinganimation == true:
		yield(main, "animfinished")
	if globals.state.playergroup.size() > 0:
		for i in globals.state.playergroup:
			var scouttemp = globals.state.findslave(i)
			var scoutawareness = 0
			if scouttemp == null:
				globals.state.playergroup.erase(i)
			else:
				if scouttemp.sagi*3+scouttemp.wit/10 > scoutawareness:
					scout = scouttemp
					scoutawareness = scouttemp.sagi*3+scouttemp.wit/10
					if scout.mods.has('augmenthearing'):
						scoutawareness += 3
	else:
		scout = globals.player
	main.checkplayergroup()
	outside.playergrouppanel()
	outside.get_node('exploreprogress/locationname').set_text(zone.name)
	globals.get_tree().get_current_scene().get_node("outside/exploreprogress").set_value((progress/max(zone.length,1))*100)
	currentzone = zone
	outside.clearbuttons()
	outside.maintext.set_bbcode('[center]'+ zone.name + '[/center]\n\n' + zone.description)
	if zone.combat == false:
		call(zone.exits[0])
		return
	else:
		main.music_set('explore')
	var array = []
	if zone.combat == true && progress >= zone.length:
		for i in zone.exits:
			var temp = self.zones[i]
			array.append({name = 'Move to ' + temp.name, function = 'zoneenter', args = temp.code})
		progress = 0
		array.insert(0,{name = 'Explore this area again', function = 'zoneenter', args = currentzone.code})
		outside.buildbuttons(array, self)
	else:
		array.append({name = "Proceed through area", function = 'enemyencounter'})
	array.append({name = "Return to Mansion", function = "mansionreturn"})
	if globals.state.sidequests.cali == 19 && zone.code == 'forest':
		array.append({name = "Look for bandits' camp", function = 'event',args = 'calibanditcamp'})
	elif (globals.state.sidequests.cali == 23 || globals.state.sidequests.cali == 24) && zone.code == 'wimbornoutskirtsexplore':
		array.append({name = "Visit slaver's camp", function = 'event',args = 'calislavercamp'})
	elif (globals.state.sidequests.cali == 25) && zone.code == 'wimbornoutskirtsexplore':
		array.append({name = "Find the Bandit",function = 'event',args = 'calistraybandit'})
	elif (globals.state.sidequests.cali == 26) && zone.code == 'grove':
		array.append({name = "Find Cali's village",function = 'event',args = 'calireturnhome'})
	if globals.state.mainquest == 13 && zone.code == 'gornoutskirtsexplore':
		array.append({name = "Search for Ivran's location",function = 'event',args = 'gornivran'})
	var hasinjuries = false
	for i in globals.state.playergroup:
		var slave = globals.state.findslave(i)
		if slave.health < slave.stats.health_max:
			hasinjuries = true
			continue
	if globals.spelldict.heal.learned == true && (globals.player.health < globals.player.stats.health_max || hasinjuries == true) :
		var tempdict = {name = "Use Heal to restore everyone's health", function = 'healeveryone'}
		if globals.resources.mana < 10:
			tempdict.disabled = true
			tempdict.tooltip = 'not enough mana'
		array.append(tempdict)
	for i in globals.state.portals:
		if i.code == zone.code && i.enabled == false:
			i.enabled = true
			outside.maintext.set_bbcode(outside.maintext.get_bbcode() + '\n\n[color=green]New portal unlocked![/color]')
	outside.buildbuttons(array, self)

func healeveryone():
	var slave
	var manaused = 0
	if globals.player.health < globals.player.stats.health_max:
		globals.player.stats.health_cur = globals.player.stats.health_max
		manaused += 10
	for i in globals.state.playergroup:
		slave = globals.state.findslave(i)
		if slave.stats.health_cur < slave.stats.health_max:
			slave.stats.health_cur = slave.stats.health_max
			manaused += 5
	manaused = min(manaused, globals.resources.mana)
	globals.resources.mana -= manaused
	main.popup("You've patched up everyone by using " + str(manaused) +  " mana. ")
	outside.playergrouppanel()

func enemyencounter():
	var enc
	var encmoveto
	var scouttemp
	var scoutawareness = -1
	outside.clearbuttons()
	if globals.state.playergroup.size() > 0:
		for i in globals.state.playergroup:
			scouttemp = globals.state.findslave(i)
			if scouttemp.sagi*3+scouttemp.wit/10 > scoutawareness:
				scout = scouttemp
				scoutawareness = scouttemp.sagi*3+scouttemp.wit/10
				if scout.mods.has('augmenthearing'):
					scoutawareness += 3
	else:
		scout = globals.player
		scoutawareness = scout.sagi*3+scout.wit/10
	if currentzone.encounters.size() > 0:
		for i in currentzone.encounters:
			enc = i[0]
			var condition = i[1]
			var chance = i[2]
			if globals.evaluate(condition) == true && rand_range(0,100) < chance:
				encmoveto = enc
				break
	if encmoveto != null:
		call(enc)
		return
	else:
		buildenemies()
		var counter = 0
		for i in enemygroup.units:
			if i.capture == true:
				var race = ''
				var sex = ''
				var age = ''
				var origins = ''
				var rand = 0
				if i.capturerace.find('area') >= 0:
					rand = rand_range(0,100)
					for ii in currentzone.races:
						if rand < ii[1]:
							race = ii[0]
							break
				elif i.capturerace.find('any') >= 0:
					race = globals.allracesarray[rand_range(0,globals.allracesarray.size())]
				elif i.capturerace.find('bandits') >= 0:
					if rand_range(0,10) <= 7:
						race = 'Human'
					else:
						race = globals.banditraces[rand_range(0,globals.banditraces.size())]
				else:
					rand = rand_range(0,100)
					for ii in i.capturerace:
						if rand < ii[1]:
							race = ii[0]
							break
				if i.capturesex.find('any') >= 0:
					sex = 'random'
				else:
					rand = rand_range(0,100)
					for ii in i.capturesex:
						if rand < ii[1]:
							sex = ii[0]
							break
				rand = rand_range(0,100)
				for ii in i.captureagepool:
					if rand < ii[1]:
						age = ii[0]
						break
				rand = rand_range(0,100)
				for ii in i.captureoriginspool:
					if rand < ii[1]:
						origins = ii[0]
						break
				var slavetemp = globals.slavegen.newslave(race, age, sex, origins)
				var location
				if !i.faction in ['bandit','monster']:
					if currentzone.exits.find("wimbornoutskirts") >= 0:
						location = 'wimborn'
					elif currentzone.exits.find("frostfordoutskirts") >= 0:
						location = 'frostford'
					elif currentzone.exits.find("gornoutskirts") >= 0:
						location = 'gorn'
					slavetemp.affiliation[location] = rand_range(30,80)
				enemygroup.units[counter].capture = slavetemp
			counter += 1
		if enemygroup.captured != null:
			var group = enemygroup.captured
			enemygroup.captured = []
			for i in group:
				var slave = capturespool[i]
				var race = ''
				var sex = ''
				var age = ''
				var origins = ''
				var rand = 0
				if slave.race.find('area') >= 0:
					rand = rand_range(0,100)
					for i in currentzone.races:
						if rand < i[1]:
							race = i[0]
							break
				elif slave.race.find('any') >= 0:
					race = globals.allracesarray[rand_range(0,globals.allracesarray.size())]
				elif slave.race.find('bandits') >= 0:
					race = globals.banditraces[rand_range(0,globals.banditraces.size())]
				else:
					rand = rand_range(0,100)
					for i in slave.race:
						if rand < i[1]:
							race = i[0]
							break
				if slave.sex.find('any') >= 0:
					sex = 'random'
				else:
					rand = rand_range(0,100)
					for i in slave.sex:
						if rand < i[1]:
							sex = i[0]
							break
				rand = rand_range(0,100)
				for ii in slave.agepool:
					if rand < ii[1]:
						age = ii[0]
						break
				rand = rand_range(0,100)
				for ii in slave.originspool:
					if rand < ii[1]:
						origins = ii[0]
						break
				slave = globals.slavegen.newslave(race, age, sex, origins)
				if !capturespool[i].faction in ['bandit','monster']:
					var location
					if currentzone.exits.find("wimbornoutskirts") >= 0:
						location = 'wimborn'
					elif currentzone.exits.find("frostfordoutskirts") >= 0:
						location = 'frostford'
					elif currentzone.exits.find("gornoutskirts") >= 0:
						location = 'gorn'
					slave.affiliation[location] = rand_range(30,80)
				enemygroup.captured.append(slave)
	if scoutawareness < enemygroup.awareness:
		ambush = true
		var text = encounterdictionary(enemygroup.descriptionambush)
		outside.maintext.set_bbcode(text)
		if enemygroup.special == null:
			encounterbuttons()
		else:
			call(enemygroup.specialambush)
	else:
		ambush = false
		var text = encounterdictionary(enemygroup.description)
		outside.maintext.set_bbcode(text)
		if enemygroup.special == null:
			encounterbuttons()
		else:
			call(enemygroup.special)


func buildenemies(enemyname = null):
	if enemyname == null:
		var rand = max(rand_range(0,100)-scout.sagi*3,0) 
		for i in currentzone.enemies:
			if rand < i[1]:
				enemygroup = str2var(var2str(enemygrouppools[i[0]]))
				break
	else:
		enemygroup = str2var(var2str(enemygrouppools[enemyname]))
	var tempunits = str2var(var2str(enemygroup.units))
	enemygroup.units = []
	for i in tempunits:
		var count = round(rand_range(i[1], i[2]))
		while count >= 1:
			enemygroup.units.append(str2var(var2str(enemypool[i[0]])))
			count -= 1


func encounterbuttons():
	var array = []
	if ambush == false:
		array.append({name = "Attack",function = "enemyfight"})
		array.append({name = "Leave", function = "enemyleave"})
	else:
		array.append({name = "Fight",function = "enemyfight"})
		array.append({name = "Escape", function = "mansionreturn"})
	outside.buildbuttons(array, self)

func slavers():
	globals.get_tree().get_current_scene().get_node('outside').clearbuttons()
	newbutton = button.duplicate()
	outside.maintext.set_bbcode(encounterdictionary(enemygroup.description))
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Greet them')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'slaversgreet')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Attack them')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'enemyfight')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Ignore them')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'enemyleave')

func banditcamp():
	globals.get_tree().get_current_scene().get_node('outside').clearbuttons()
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Attack them')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'enemyfight')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Ignore them')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'enemyleave')

func slaversgreet():
	globals.get_tree().get_current_scene().get_node('outside').clearbuttons()
	globals.get_tree().get_current_scene().get_node('outside').maintext.set_bbcode(globals.player.dictionary("You reveal yourself to the slavers' group and wondering if they'd be willing to part with their merchandise saving them hassle of transportation.\n\n- You, $sir, know how to bargain. We'll agree to part with our treasure here for ")+str(max(round(enemygroup.captured.calculateprice()*0.3),40))+" gold.\n\nYou still might try to take their hostage by force, but given they know about your presence, you are at considerable disadvantage. ")
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Inspect')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'inspectenemy')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Agree on the deal')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'slaverbuy')
	if globals.resources.gold < max((round(enemygroup.captured.calculateprice()*0.3)),40):
		newbutton.set_disabled(true)
		newbutton.set_tooltip("You don't have enough gold.")
	if globals.spelldict.mindread.learned == true:
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Cast Mindread to check personality')
		newbutton.set_hidden(false)
		newbutton.connect("pressed",self,'mindreadcapturee', ['slavers'])
		if globals.spelldict.mindread.manacost > globals.resources.mana:
			newbutton.set_disabled(true)
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Fight')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'enemyfight')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Refuse and leave')
	newbutton.set_hidden(false)
	newbutton.connect("pressed",self,'enemyleave')

func snailevent():
	var array = []
	outside.maintext.set_bbcode("You come across a humongous snail making its way through the trees. It makes you remember hearing how you could use it for farming additional income but you will likely need to sacrifice some food to tame it first. ")
	if globals.resources.food >= 200:
		array.append({name = 'Feed Snail (200 food)', function = 'snailget'})
	else:
		array.append({name = 'Feed Snail (200 food)', function = 'snailget', disabled = true, tooltip = "not enough food"})
	array.append({name = "Ignore it", function = "zoneenter", args = 'grove'})
	outside.buildbuttons(array,self)

func snailget():
	globals.resources.food -= 200
	globals.state.snails += 1
	main.popup("You've brought a giant snail back with you and left it at your farm. ")
	main._on_mansion_pressed()

func slaverbuy():
	globals.resources.gold -= max(round(enemygroup.captured.calculateprice()*0.3),30)
	enemycapture()
	globals.get_tree().get_current_scene().popup("You purchase slavers' captive and return to mansion. " )

func inspectenemy():
	globals.get_tree().get_current_scene().popup(enemygroup.captured.description_small())

func mindreadcapturee(state = 'encounter'):
	globals.get_tree().get_current_scene().get_node("spellnode").slave = enemygroup.captured
	globals.get_tree().get_current_scene().get_node("spellnode").mindreadeffect()
	if state == 'win':
		enemydefeated()
	elif state == 'slavers':
		slaversgreet()
	else:
		encounterbuttons()

func mindreadenemy():
	var spell = globals.spelldict.mindread
	var text = ''
	globals.resources.mana -= spell.manacost
	globals.get_tree().get_current_scene().popup(str(enemygroup.stats))
	
	encounterbuttons()

func enemyleave():
	progress += 1
	var text = ''
	for i in globals.state.playergroup:
		var slave = globals.state.findslave(i)
		slave.energy = -5
		if slave.energy <= 10:
			globals.state.playergroup.erase(slave.id)
			text += slave.name + " is too exhausted to continue and returns back to mansion. "
	zoneenter(currentzone.code)
	if text != '':
		outside.maintext.set_bbcode(outside.maintext.get_bbcode()+'\n[color=yellow]'+text+'[/color]')

func enemyfight():
	outside.maintext.set_bbcode('')
	outside.clearbuttons()
	main.get_node("combat").currentenemies = enemygroup.units
	main.get_node("combat").start_battle()

var capturedtojail = 0

func enemydefeated():
	if launchonwin != null:
		globals.events.call(launchonwin)
		launchonwin = null
		return
	main.checkplayergroup()
	var text = 'You have defeated enemy group!\n'
	defeated = {units = [], names = [], select = [], faction = []}
	var ranger = false
	for i in globals.state.playergroup:
		if globals.state.findslave(i).spec == 'ranger':
			ranger = true
	capturedtojail = 0
	#Fight rewards
	var winpanel = main.get_node("explorationnode/winningpanel")
	var goldearned = 0
	var expearned = 0
	var supplyearned = 0
	for unit in enemygroup.units:
		if unit.capture != null:
			defeated.units.append(unit.capture)
			defeated.names.append(unit.name)
			defeated.select.append(0)
			defeated.faction.append(unit.faction)
		for i in unit.rewardpool:
			var chance = unit.rewardpool[i]
			if ranger == true:
				chance = chance*1.5
			if rand_range(0,100) <= chance: 
				if i == 'gold':
					goldearned += round(rand_range(unit.rewardgold[0], unit.rewardgold[1]))
				elif i == 'supply':
					supplyearned += round(rand_range(unit.rewardsupply.low, unit.rewardsupply.high))
				else:
					var item = globals.itemdict[i]
					text = text + '\nLooted ' + item.name + '.'
					item.amount += 1
		expearned += unit.rewardexp
	globals.resources.gold += goldearned
	text += '\nYou have received a total sum of [color=yellow]' + str(round(goldearned)) +'[/color] pieces of gold and [color=aqua]' + str(expearned) + '[/color] experience points. '
	if supplyearned > 0:
		globals.itemdict.supply.amount += supplyearned
		text += "\nYou have collected " + str(supplyearned) + " units of supplies from defeated enemies. "
	globals.player.level.xp += round(expearned/(globals.state.playergroup.size()+1))
	for i in globals.state.playergroup:
		var slave = globals.state.findslave(i)
		slave.level.xp += round(expearned/globals.state.playergroup.size()+1)
		if slave.health > slave.stats.health_max/1.3:
			slave.cour += rand_range(1,3)
	
	winpanel.get_node("defeatedmindread").set_hidden(true)
	
	if defeated.units.size() > 0:
		text += 'Your group gathers defeated opponents in one place for you to decide what to do about them. \n'
	if enemygroup.captured != null:
		text += 'You are also free to decide what you wish to do with bystanders, who were in possession of your opponents. \n'
		for i in enemygroup.captured:
			defeated.units.append(i)
			defeated.names.append('Captured')
			defeated.select.append(0)
			defeated.faction.append('stranger')
	
	for i in winpanel.get_node("ScrollContainer/VBoxContainer").get_children():
		if i != winpanel.get_node("ScrollContainer/VBoxContainer/Button"):
			i.set_hidden(true)
			i.free()
	
	winpanel.set_hidden(false)
	winpanel.get_node("wintext").set_bbcode(text)
	for i in range(0, defeated.units.size()):
		defeated.units[i].stress += rand_range(20, 50)
		defeated.units[i].obed += rand_range(10, 20)
		defeated.units[i].health = -rand_range(40,70)
		if defeated.names[i] == 'Captured':
			defeated.units[i].obed += rand_range(10,20)
			defeated.units[i].loyal += rand_range(5,15)
		var newbutton = winpanel.get_node("ScrollContainer/VBoxContainer/Button").duplicate()
		winpanel.get_node("ScrollContainer/VBoxContainer").add_child(newbutton)
		newbutton.set_hidden(false)
		newbutton.get_node("Label").set_text(defeated.names[i] + ' ' + defeated.units[i].sex+ ' ' + defeated.units[i].age + ' ' + defeated.units[i].race)
		newbutton.connect("pressed", self, 'defeatedselected', [defeated.units[i]])
		newbutton.get_node("choice").set_meta('slave', defeated.units[i])
		newbutton.get_node("choice").add_to_group('winoption')
		newbutton.get_node("choice").connect("item_selected",self, 'defeatedchoice', [defeated.units[i], newbutton.get_node("choice")])
	checkjailbutton()
	
	
	if globals.state.sidequests.cali == 18 && defeated.names.find('Bandit') >= 0 && currentzone.code == 'forest':
		main.popup("One of the defeated bandits in exchange for their life reveal location of their camp you've been in search for. ")
		globals.state.sidequests.cali = 19



func defeatedselected(slave):
	var winpanel = main.get_node("explorationnode/winningpanel")
	winpanel.get_node("defeateddescript").set_bbcode(slave.description_small(true))
	if globals.spelldict.mindread.learned == true:
		winpanel.get_node("defeatedmindread").set_hidden(false)
		winpanel.get_node("defeateddescript").set_meta('slave', slave)
		if globals.resources.mana >= globals.spelldict.mindread.manacost:
			winpanel.get_node("defeatedmindread").set_disabled(false)
		else:
			winpanel.get_node("defeatedmindread").set_disabled(true)
	else:
		winpanel.get_node("defeatedmindread").set_hidden(true)

func defeatedchoice(ID, slave, node):
	checkjailbutton()
	defeated.select[defeated.units.find(slave)] = ID




func checkjailbutton():
	var counter = 0
	var winpanel = main.get_node("explorationnode/winningpanel")
	for i in get_tree().get_nodes_in_group('winoption'):
		if i.get_item_text(i.get_selected()) == 'Jail':
			counter += 1
	winpanel.get_node("Label").set_text("Defeated and Captured | Jail cells left: " + str(globals.state.rooms.jail - (globals.count_sleepers().jail + counter)) )
	if globals.state.rooms.jail <= globals.count_sleepers().jail + counter:
		for i in get_tree().get_nodes_in_group('winoption'):
			i.set_item_disabled(2, true)
	else:
		for i in get_tree().get_nodes_in_group('winoption'):
			i.set_item_disabled(2, false)


func _on_defeatedmindread_pressed():
	var spell = globals.spelldict.mindread
	var text = ''
	var winpanel = main.get_node("explorationnode/winningpanel")
	globals.get_tree().get_current_scene().get_node("spellnode").slave = winpanel.get_node("defeateddescript").get_meta('slave')
	globals.get_tree().get_current_scene().get_node("spellnode").mindreadeffect()
	defeatedselected(winpanel.get_node("defeateddescript").get_meta('slave'))



func _on_confirmwinning_pressed(secondary = false):
	var text = ''
	var selling = false
	var sellyourself = false
	var orgy = false
	var orgyarray = []
	var location
	var reward = false
	if currentzone.exits.find("wimbornoutskirts") >= 0:
		location = 'wimborn'
	elif currentzone.exits.find("frostfordoutskirts") >= 0:
		location = 'frostford'
	elif currentzone.exits.find("gornoutskirts") >= 0:
		location = 'gorn'
	for i in get_tree().get_nodes_in_group('winoption'):
		if i.get_item_text(i.get_selected()) == 'Sell':
			selling = true
	if selling == true && secondary == false:
		get_node("winningpanel/sellpanel").set_hidden(false)
		get_node("winningpanel/sellpanel/selectlist").clear()
		get_node("winningpanel/sellpanel/selectlist").add_item('Personal')
		for i in globals.state.playergroup:
			get_node("winningpanel/sellpanel/selectlist").add_item(globals.state.findslave(i).name)
		return
	else:
		if selling == true:
			if get_node("winningpanel/sellpanel/selectlist").get_selected() == 0:
				sellyourself = true
			else:
				var sellslave = globals.state.findslave(globals.state.playergroup[get_node("winningpanel/sellpanel/selectlist").get_selected()-1])
				globals.state.playergroup.remove(get_node("winningpanel/sellpanel/selectlist").get_selected()-1)
				text += sellslave.name + ' left you to transit capturees to nearby slave market.\n'
			for i in range(0, defeated.units.size()):
				if defeated.select[i] == 1:
					if defeated.faction[i] == 'stranger':
						globals.state.reputation[location] -= 1.5
					elif defeated.faction[i] == 'bandit':
						globals.state.reputation[location] += 1
					var rand = rand_range(5,10)
					text += defeated.names[i] + ' has been sold for ' + str(round(max(defeated.units[i].calculateprice()*0.3,rand))) + ' gold.\n'
					globals.resources.gold += max(defeated.units[i].calculateprice()*0.3,rand)
		for i in range(0, defeated.units.size()):
			if defeated.select[i] == 0:
				if defeated.names[i] != 'Captured':
					text += defeated.units[i].dictionary("You have left $race $child alone.\n")
				else:
					text += defeated.units[i].dictionary("You have released $race $child and set $him free.\n")
					globals.state.reputation[location] += rand_range(2,3)
					if rand_range(0,100) < 25 && reward == false:
						reward = true
						rewardslave = defeated.units[i]
						rewardslavename = defeated.names[i]
			elif defeated.select[i] == 2:
				var slave = defeated.units[i]
				if defeated.faction[i] == 'stranger':
					globals.state.reputation[location] -= 1
				text += defeated.names[i] + " has been sent to your jail. \n"
				enemycapture(slave)
			elif defeated.select[i] == 3:
				if !defeated.faction[i] in ['monster','bandit']:
					globals.state.reputation[location] -= 3
				elif defeated.faction[i] == 'bandit':
					globals.state.reputation[location] -= 1
				text += defeated.names[i] + " has been killed. \n"
			elif defeated.select[i] == 4:
				if !defeated.faction[i] in ['bandit','monster']:
					globals.state.reputation[location] -= rand_range(0,1)
				orgy = true
				orgyarray.append(defeated.units[i])
	if sellyourself == true:
		get_node("winningpanel").set_hidden(true)
		main._on_mansion_pressed()
	else:
		get_node("winningpanel").set_hidden(true)
		enemyleave()
	get_node("winningpanel/defeateddescript").set_bbcode('')
	outside.playergrouppanel()
	if orgy == true:
		var totalmanagain = 0
		if orgyarray.size() >= 2: ### See if there's more than 1 enemy to rape
			text += "After freeing those left from their clothes, you joyfully start to savour their bodies one after another. "
		else:
			text += "You undress sole defeated and without further hesitation mercilessly rape " + orgyarray[0].dictionary("$race $child") + ". \n"
		for i in globals.state.playergroup:
			var slave = globals.state.findslave(i)
			if slave.sexuals.unlocked == false:
				if slave.loyal < 30:
					text+= slave.dictionary('\n$name watches at your actions with digust, eventually averting $his eyes. ')
					slave.obed += -rand_range(15,25)
				else:
					text += slave.dictionary('\n$name watches at your deeds with interest, occassionally rustling around $his waist. ')
					slave.lust = 20
			elif slave.sexuals.unlocked == true:
				if slave.lust >= 50 && slave.dom >= 40:
					slave.sexuals.affection += round(rand_range(2,4))
					slave.dom = rand_range(6,12)
					text += slave.dictionary('\n$name, overwhelemed by situation, joins you and pleasure $himself with one of the capturees. ')
				else:
					text += slave.dictionary("\n$name does not appear to be very interested in ongoing action and just waits patiently.")
		for i in orgyarray:
			var temp = rand_range(3,5)
			globals.resources.mana += temp
			totalmanagain += temp
		text += "You've earned [color=aqua]" + str(round(totalmanagain)) + "[/color] mana. " 
	if reward == true:
		capturereward()
	if text != '':
		main.popup(text)

var rewardslave
var rewardslavename

func capturereward():
	var text = ""
	var buttons = [['Take no reward','capturedecide',1],['Ask for material reward','capturedecide',2],['Ask for sex','capturedecide',3],['Ask to join you','capturedecide',4]]
	text = "As you are about to move on, " + rewardslavename + " person, that you have rescued, appeals to you. $His name is $name and $he's very thankful for your help. $race $child wishes to repay you somehow.  "
	
	
	main.dialogue(false,self,rewardslave.dictionary(text),buttons)

func capturedecide(stage): #1 - no reward, 2 - material, 3 - sex, 4 - join
	var text = ""
	var location
	if currentzone.exits.find("wimbornoutskirts") >= 0:
		location = 'wimborn'
	elif currentzone.exits.find("frostfordoutskirts") >= 0:
		location = 'frostford'
	elif currentzone.exits.find("gornoutskirts") >= 0:
		location = 'gorn'
	
	if stage == 1:
		text = "$race $child is surprised by your generosity, and after thanking you again, leaves. "
		globals.state.reputation[location] += 1
	elif stage == 2:
		text = "After getting through $his belongings, $name passes you some valueable and gold. "
		globals.resources.gold += round(rand_range(3,6)*10)
	elif stage == 3:
		if rand_range(0,100) >= 35:
			text = "$name hastily refuses and retreats excusing $himself. "
		else:
			text = "After brief pause, $name gives you an accepting nod. After you seclude to nearby bushes, $he rewards you with passionate session. "
			globals.resources.mana += 5
	elif stage == 4:
		if rand_range(0,100) >= 20:
			text = "$name excuses $himself, but can't accept your proposal and quickly leaves. "
		else:
			globals.slaves = rewardslave
			text = "$name observes you for some time, measuring you words, but to your surprise, $he complies either out of symphathy, or out of desperate life $he had to carry. "
	main.dialogue(true,self,rewardslave.dictionary(text))
	

func _on_sellconfirm_pressed():
	_on_confirmwinning_pressed(true)
	get_node("winningpanel/sellpanel").set_hidden(true)


func enemycapture(slave):
	slave.sleep = 'jail'
	var effect = globals.effectdict.captured
	var dict = {'slave':0.7, 'poor':1,'commoner':1.2,"rich": 2, "noble": 4}
	effect.duration = round((4 + (slave.conf+slave.cour)/20) * dict[slave.origins])
	slave.add_effect(effect)
	if slave.race in ['Lamia','Arachna','Harpy','Nereid','Slime','Scylla','Dryad','Fairy']:
		slave.add_trait(globals.origins.trait('Uncivilized'))
	globals.slaves = slave


func wimbornoutskirts():
	var array = []
	array.append({name = "Explore Outskirts", function = 'zoneenter', args = 'wimbornoutskirtsexplore'})
	array.append({name = "Explore Forest", function = 'zoneenter', args = 'forest'})
	array.append({name = "Explore Deep Elven Grove", function = 'zoneenter', args = 'elvenforest'})
	array.append({name = "Explore Far Eerie Woods", function = 'zoneenter', args = 'grove'})
	array.append({name = "Return to Wimborn", function = 'wimborn'})
	outside.buildbuttons(array, self)

func gornoutskirts():
	var array = []
	array.append({name = "Explore Outskirts", function = 'zoneenter', args = 'gornoutskirtsexplore'})
	array.append({name = "Explore Mountain Ridge", function = 'zoneenter', args = 'mountains'})
	array.append({name = "Explore Sea Beach", function = 'zoneenter', args = 'sea'})
	array.append({name = "Return to Gorn", function = 'zoneenter', args = 'gorn'})
	outside.buildbuttons(array,self)


func frostfordoutskirts():
	var array = []
	array.append({name = "Explore Outskirts", function = 'zoneenter', args = 'frostfordoutskirtsexplore'})
	array.append({name = "Explore Marsh", function = 'zoneenter', args = 'marsh'})
	array.append({name = "Return to Frostford", function = 'zoneenter', args = 'frostford'})
	outside.buildbuttons(array,self)

func wimborn():
	main.get_node('outside').town()
	main.get_node('outside').gooutside()

func gorn():
	outside.location = 'gorn'
	main.music_set('gorn')
	var array = []
	array.append({name = "Visit local Slave Guild", function = 'gornslaveguild'})
	if globals.state.mainquest in [12,13,14,15]:
		array.append({name = "Visit Palace", function = 'gornpalace'})
	if globals.state.sidequests.ivran in ['tobetaken','tobealtered','potionreceived'] || globals.state.mainquest >= 16:
		array.append({name = "Visit Alchemist", function = 'gornayda'})
	array.append({name = "Gorn's Market", function = 'gornmarket'})
	array.append({name = "Outskirts", function = 'zoneenter', args = 'gornoutskirts'})
	array.append({name = "Return to Mansion", function = 'mansionreturn'})
	outside.buildbuttons(array,self)

func gornmarket():
	outside.shopinitiate('gornmarket')

func gornpalace():
	globals.events.gornpalace()
	zoneenter('gorn')

func gornayda():
	globals.events.gornayda()

func frostford():
	outside.location = 'frostford'
	main.music_set('gorn')
	var array = []
	array.append({name = "Visit local Slave Guild", function = 'frostfordslaveguild'})
	array.append({name = "Frostford's Market", function = 'frostfordmarket'})
	array.append({name = "Outskirts", function = 'zoneenter', args = 'frostfordoutskirts'})
	array.append({name = "Return to Mansion", function = 'mansionreturn'})
	outside.buildbuttons(array,self)

func frostfordmarket():
	outside.shopinitiate('frostfordmarket')

func gornslaveguild():
	outside.slaveguild('gorn')

func frostfordslaveguild():
	outside.slaveguild('frostford')

func shaliq():
	var array = []
	if globals.state.sidequests.cali == 17:
		globals.events.calivillage()
	elif globals.state.sidequests.cali in [20,21]:
		globals.events.calivillage2()
	array.append({name = "Visit Local Trader", function = 'shaliqshop'})
	if globals.state.sidequests.dolin >= 7:
		array.append({name = "Visit Dolin's house", function = "dolinhouse"})
	array.append({name = "Leave to the forest", function = 'zoneenter', args = 'forest'})
	if globals.state.sidequests.dolin == 6:
		globals.state.sidequests.dolin = 7
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("You lead Dolin back to the village she resides, as she tells you about herself. She's a researcher and inventor, came here for some inspirations and peace of mind.\n\n- Thanks again $name! If you are interested, come see me around here. I may have something interesting for you."))
	elif globals.state.sidequests.dolin == 15:
		globals.state.sidequests.dolin = 16
		outside.maintext.set_bbcode("You lead Dolin back to her house and give her some time to rest and clean herself.")
		
	outside.buildbuttons(array,self)

func shaliqshop():
	outside.shopinitiate('shaliqshop')

#	buttoncontainer = globals.get_tree().get_current_scene().get_node("outside").get_node("outsidebuttoncontainer")
#	button = globals.get_tree().get_current_scene().get_node("outside").get_node("outsidebuttoncontainer/buttontemplate")
#	if globals.state.sidequests.dolin >= 7:
#		newbutton = button.duplicate()
#		buttoncontainer.add_child(newbutton)
#		newbutton.set_text("Visit Dolin's house")
#		newbutton.set_hidden(false)
#		newbutton.connect('pressed', self, 'dolinhouse')
#	newbutton = button.duplicate()
#	buttoncontainer.add_child(newbutton)
#	newbutton.set_text('Leave to the forest')
#	newbutton.set_hidden(false)
#	newbutton.connect('pressed', self, 'zoneenter', ['forest'] )
#	if globals.state.sidequests.dolin == 6:
#		globals.state.sidequests.dolin = 7
#		outside.maintext.set_bbcode(globals.player.dictionaryplayer("You lead Dolin back to the village she resides, as she tells you about herself. She's a researcher and inventor, came here for some inspirations and peace of mind.\n\n- Thanks again $name! If you are interested, come see me around here. I may have something interesting for you."))
#	elif globals.state.sidequests.dolin == 15:
#		globals.state.sidequests.dolin = 16
#		outside.maintext.set_bbcode("You lead Dolin back to her house and give her some time to rest and clean herself.")

func dolinforest(state = globals.state.sidequests.dolin):
	globals.state.sidequests.dolin = state
	outside.clearbuttons()
	var havegnomemember = false
	for i in globals.state.playergroup:
		var slave = globals.state.findslave(i)
		if slave.race == 'Gnome':
			havegnomemember = true
	if scout.sagi >= 3 && globals.state.sidequests.dolin == 0 && scout.race != 'Gnome':
		outside.maintext.set_bbcode('You spot a lone gnome girl who seems lost. She takes notice of your presence and starts to panic, preparing to run away before you’ve even lifted a finger. It’s oddly refreshing to be feared without having to prove anything.')
		if globals.spelldict.sedation.learned == true && globals.spelldict.sedation.manacost <= globals.resources.mana:
			newbutton = button.duplicate()
			buttoncontainer.add_child(newbutton)
			newbutton.set_text('Cast Sedation')
			newbutton.set_hidden(false)
			newbutton.connect('pressed', self, 'dolinforest', [1] )
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Leave her alone')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['forest'] )
	elif scout.sagi >= 3 && havegnomemember == true && globals.state.sidequests.dolin == 0:
		outside.maintext.set_bbcode("You spot a lone gnome girl who seems lost. She takes notice of your presence and seems to panic for a moment. She prepares to run away, but calms down when she notices another gnome in your party.")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Talk with her')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinforest', [2] )
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Leave her alone')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['forest'] )
	elif globals.state.sidequests.dolin == 1:
		globals.resources.mana -= globals.spelldict.sedation.manacost
		outside.maintext.set_bbcode("You quickly cast Sedation on her. She shoots you a puzzled look, blinking rapidly for several seconds until the magic has run its course, and she’s ready to talk.")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Talk with her')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinforest', [2] )
	elif globals.state.sidequests.dolin == 2:
		outside.maintext.set_bbcode("- Oh, uh, h-hello. I, uh, kinda thought you were some kind of giant, gnome-eating bandit for a second there. N-not that big people terrify me or anything!\n\nShe coughs and rubs one of her arms, clearly embarrassed.\n\n- Well... Actually I moved to a nearby village, but I just can't learn the surroundings, and keep getting lost. I'm just not used to all this open… Openness.\n\n- Say, do you happen to know the road? Could you help me out?")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Lead her to the Shaliq')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinforest', [4] )
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text("Tell her you don't know it")
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinforest', [3] )
	elif globals.state.sidequests.dolin == 3:
		outside.maintext.set_bbcode("- Oh, I see... Well, don't worry, I'll manage! Good luck then, see you around!\n\nSaying that, she quickly retreats, disappearing from sight.")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		globals.state.sidequests.dolin = 5
		newbutton.set_text('Move on')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['forest'] )
	elif globals.state.sidequests.dolin == 4:
		outside.maintext.set_bbcode("- Really?! Oh thank goodness, you’re a lifesaver, literally! My name’s Dolin by the way. Man am I glad I didn’t run away from you.\n\nShe seems genuinely relieved that you can show her the way.\n\n- B-but don’t get me wrong, it’s not like tall people scare me or anything like that... A-anyway! We should really head back before it gets too dark.")
		globals.state.sidequests.dolin = 6
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Proceed to Shaliq with Dolin')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['shaliq'] )
	elif globals.state.sidequests.dolin == 5:
		outside.maintext.set_bbcode("- Oh, it's you again! Ugh... Yeah, I kinda forgot the road again. I should really start carrying around one of those absurd round things with the pointy dealy. Looks like you know the way better than I do, have you figured out the roads yet?")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Lead her to the Shaliq')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinforest', [4] )
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text("Tell her you don't know it")
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinforest', [3] )
	else:
		outside.maintext.set_bbcode("You almost spot someone in the bushes but they escape before you can make your move.\n\n[color=yellow](Scout check failed)[/color]")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Move on')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['forest'] )

func dolinhouse(state = globals.state.sidequests.dolin):
	globals.state.sidequests.dolin = state
	outside.clearbuttons()
	buttoncontainer = globals.get_tree().get_current_scene().get_node("outside").get_node("outsidebuttoncontainer")
	button = globals.get_tree().get_current_scene().get_node("outside").get_node("outsidebuttoncontainer/buttontemplate")
	if globals.state.sidequests.dolin == 7:
		outside.maintext.set_bbcode("Dolin invites you into her spacious hut, a variety of odd looking gadgets and tools are neatly arranged throughout her abode.\n\n- Oh, hello! It's nice that you actually came! It's kinda never occurred to me that you’re a mage before. From what I’ve gathered, you aren’t from around these parts, so I guess you use teleportation, huh?\n\n- I'm not all that into magic myself, but I’ve found some use for it. Care to make a deal? Provide me with some mana, and I can share a spell an old friend passed onto me during some experiments I was running at the time.\n\n- It lets you influence the target’s mind, letting you plant some serious suggestions. I’ve never really been into mind control, but you should have plenty of use for it. So how about it; 25 mana for the spell sound fair?")
		globals.state.sidequests.dolin = 8
	elif globals.state.sidequests.dolin == 8:
		outside.maintext.set_bbcode("- You're back! So, how are you doing? Ready to help me out?")
		if globals.resources.mana >= 25:
			newbutton = button.duplicate()
			buttoncontainer.add_child(newbutton)
			newbutton.set_text('Agree')
			newbutton.set_hidden(false)
			newbutton.connect('pressed', self, 'dolinhouse', [9] )
	elif globals.state.sidequests.dolin == 9:
		globals.state.sidequests.dolin = 10
		globals.resources.mana -= 25
		globals.spelldict.entrancement.learned = true
		if globals.abilities.abilitydict.has('entrancement') == true:
			globals.player.ability.append('entrancement')
		if globals.player.penis.number >= 1:
			outside.maintext.set_bbcode("- Great! Just stay right there for a moment!\n\nShe leaves you alone for a moment to dig through her closet, eventually returning with an ordinary looking glass tube that has some sort of strange device attached to it.\n\n- Found it. I haven’t actually had the chance to use it before, but it should work. And, um… If you don’t mind, I can help out, I guess.\n\nDeciding to give her the lead, you follow Dolin over to a bench and take a seat. She carefully rubs at your groin, and with a surprised gasp, she frees your manhood, clearly intimidated by its size.\n\n- I-I uh, guess it’s only natural that you’d be big in more ways than one...\n\nThe awkward little gnome takes hold of your penis, at first gently stroking your cock, and adjusting her hand movements and pressure to try and give you the most pleasure. Her innocence and cute looks are enough to keep you going, but it’s clear she won’t be getting you off with her lack of technique this way, a fact she seems quick to catch onto. With clear arousal and determination in her eyes, she adds her mouth into the mix.\n\nWith a hint of worship, the eager gnome dutifully attends to your throbbing member, stroking and sucking so you can reach orgasm much faster, and you’re more than happy to oblige her efforts. With each movement she becomes just a little more confident, acting more and more bold, and you realize she’s observing you; looking at every little reaction and learning your sweet spots.\n\nAs you’re about to cum, Dolin pulls your cock out of her mouth, pushes it into the device she brought out at the start, and finishes you off with her hand. Your orgrasm is no different from any other, but for once you feel yourself giving mana instead of taking it, as the device sucks the bounty into its storage.\n\nDolin gleams with joy, happily smiling as she runs off to put her new possession away.\n\n[color=yellow]You have learned the Entrancement Spell.[/color]")
		else:
			outside.maintext.set_bbcode("Dolin gleams with joy, happily smiling as she runs off to put her new possession away.\n\n[color=yellow]You have learned the Entrancement Spell.[/color]")
	elif globals.state.sidequests.dolin == 10:
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("- $name! How are you doing? Sorry, I'm bit busy with experiment. But please come back some other time!"))
	elif globals.state.sidequests.dolin == 11:
		globals.state.sidequests.dolin = 12
		outside.maintext.set_bbcode("You knock, and go inside, but it seems there's nobody around. After looking around a bit you find a note left by Dolin, saying she went to the deeper parts of the forest. As it seems that she hasn't been around for some time, you decide it may be a good idea to look for her.")
	elif globals.state.sidequests.dolin == 12:
		outside.maintext.set_bbcode("You already searched and couldn't find Dolin here.")
	elif globals.state.sidequests.dolin == 16:
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("As you come in, you can see Dolin has regained her composure, although something about her isn’t quite right. Her face is bright red and she certainly looks restless.\n\n- $name, thanks for saving me from there. That was embarrassing... letting you see me like that...\n\n- I can’t believe I fell into that damn hole. After a while I just got so hungry and ate some strange berries... Then I just couldn't think straight for days... I think there's also something in the air.\n\n- But that aside, I need your help. You see... I still can't calm down. It's not as bad as it was there, but I just can't concentrate on anything. I have a recipe for an antidote which should help. Can...can you make it for me? Please? I know you should have some equipment. Sorry for giving you so much trouble, but there's really nobody else I could ask right now.\n\nYou take the recipe from her and promise to return soon."))
		globals.state.sidequests.dolin = 17
	elif globals.state.sidequests.dolin == 17:
		outside.maintext.set_bbcode("You decide it's better not to needlessly disturb Dolin right now. ")
	elif globals.state.sidequests.dolin == 18:
		globals.state.sidequests.dolin = 30
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("As you pass antidote bottle to the Dolin, she looks very relieved.\n\n- Thank you, $name! You’re a lifesaver.\n\nAfter some time she completely calms down and you can see her relax.\n\n- Can't believe it happened to me... I really owe you one, I guess. Um... how about this?\n\nShe spends some time looking through her stuff, until finally finds an old looking scroll.\n\n- This is supposed to be a dangerous spell, but you helped me, and I think you would use it responsibly. Take it. And... I wouldn't mind if you come see me again sometimes, if you aren’t too disturbed after seeing me like that."))
	elif globals.state.sidequests.dolin == 19:
		globals.state.sidequests.dolin = 32
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("As you pass the disguised bottle to the Dolin, she looks very relieved.\n\n- Thank you, $name! I knew I could rely on you!\n\nAs she gulps down on potion, her face  becomes more relaxed.\n\n- Huh... this has an interesting taste... What was I doing again...\n\nAs the amnesia potion starts to take effect, Dolin appears to be less and less conscious of the world around her. With her mind in such a vulnerable state, it’s a trivial matter to use your entrancement spell to implant a number of suggestions within her. As you lead her back to your mansion, you reflect on the irony of using the very spell she taught you to brainwash her."))
		dolinmake()
		dolin.loyal += 50
		dolin.wit = 75
		globals.slaves = dolin
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Continue')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', main,'_on_mansion_pressed' )
	elif globals.state.sidequests.dolin == 20:
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("As you pass the disguised bottle to the Dolin, she looks very relieved.\n\n- Thank you, $name! I knew I could rely on you!\n\nAs she gulps down on potion, she looks slightly puzzled.\n\n- Huh... this is a different taste from what I expected...\n\nAfter a few moments she starts panting, the unquenchable lust in her body growing even wilder than it was before.\n\n- No way!.. I must have... Mixed up the formula... Ah!...\n\nAs her body explodes into orgasm, she's completely at a loss for words. only having you in her sight.\n\nAfter a few joyful hours you realize all of her free will is overwritten by wild desire. After a minor break you make a decision:"))
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Take her into your mansion')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinhouse', [25] )
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Sell her to the brothel')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolinhouse', [26] )
	elif globals.state.sidequests.dolin == 25:
		globals.state.sidequests.dolin = 31
		dolinmake()
		dolin.sexuals.affection += round(rand_range(20,50))
		dolin.loyal += 25
		dolin.sexuals.affection += 250
		dolin.add_trait(globals.origins.trait('Sex-crazed'))
		globals.slaves = dolin
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("Sex-crazed Dolin becomes your servant."))
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Continue')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', main,'_on_mansion_pressed' )
	elif globals.state.sidequests.dolin == 26:
		globals.state.sidequests.dolin = 33
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("You lead whats left of gnome girl to the local brothel. After some haggling, you make a deal for 500 gold, and leave her in the custody of the owner. It seems that her new occupation fits her animal instincts, making any further involvement of yours pointless."))
		globals.resources.gold += 500
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Continue')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', main,'_on_mansion_pressed' )
	elif globals.state.sidequests.dolin == 30:
		outside.maintext.set_bbcode("Dolin happily greets you as you visit her and you spend some relaxed time together. It seems she grew very fond of you. ")
	elif globals.state.sidequests.dolin in [31,32,33]:
		outside.maintext.set_bbcode("This place is empty now. There's no point to return here anymore.")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Return')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['shaliq'] )
	
	
	
	
	if globals.state.sidequests.dolin in [22,20,25,26,31,32,33]:
		pass
	else:
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Return')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['shaliq'] )

var dolin
func dolinmake():
	var dolintemp = globals.slavegen.newslave('Gnome', 'adult', 'female', 'commoner')
	dolintemp.name = 'Dolin'
	dolintemp.unique = 'Dolin'
	dolintemp.surname = 'Seyfert'
	dolintemp.tits.size = 'average'
	dolintemp.ass = 'big'
	dolintemp.face.beauty = 60
	dolintemp.hairlength = 'shoulder'
	dolintemp.height = 'tiny'
	dolintemp.haircolor = 'red'
	dolintemp.eyecolor = 'green'
	dolintemp.skin = 'fair'
	dolintemp.hairstyle = 'ponytail'
	dolintemp.pussy.virgin = false
	dolintemp.pussy.first = 'unknown'
	dolintemp.relatives.father = -1
	dolintemp.relatives.mother = -1
	dolintemp.sexuals.affection += 10
	dolintemp.wit = 15
	dolintemp.cleartraits()
	dolintemp.obed += 90
	dolin = dolintemp

func dolingrove(state = globals.state.sidequests.dolin):
	globals.state.sidequests.dolin = state
	outside.clearbuttons()
	buttoncontainer = globals.get_tree().get_current_scene().get_node("outside").get_node("outsidebuttoncontainer")
	button = globals.get_tree().get_current_scene().get_node("outside").get_node("outsidebuttoncontainer/buttontemplate")
	if globals.state.sidequests.dolin == 12:
		outside.maintext.set_bbcode(globals.player.dictionaryplayer("After spending some time managing your way through uninviting flora, you come across a steep ravine. From above you spot traces of someone been through recently. As you move along it, you eventually  find a small shadow at the bottom of ravine. Even though there's some noise, calling it out has no reaction and you decide to descend into the ravine.\n\nUnsurprisingly, the shadow turns out to be your old acquaintance Dolin. She is hardly recognisable, as she crawls half-naked, on the ground. She barely recognizes you, being semiconscious, moaning and blissfully rubbing her bare crotch.\n\n- $name?... You found me... I want you... Please, I can't... I can't calm down...\n\nAs the gnome girl raises up and stumbles your direction, she latches on you while rubbing her soaked thighs together.\n\n- I just... Need to calm  down... "))
		if globals.player.penis.number >= 1:
			outside.maintext.set_bbcode(outside.maintext.get_bbcode() + 'I want your cock.')
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Fuck her')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolingrove', [13] )
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Masturbate her')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'dolingrove', [14] )
	if globals.state.sidequests.dolin == 13:
		outside.maintext.set_bbcode("You give in to the horny girl's temptations. With a blissful expression she pulls down your pants and lustfully strokes your cock, making it fully erect. As you lay down on the grass, she quickly crawls on top and clumsily begins to ride you with her soaking pussy. Her moans quickly grow louder and and her frantic movements indicate she’s close to orgasming.\n\nAs you both convulse in orgasm, she briefly faints on top of you. This makes you slightly worried, but a few nudges bring her back to consciousness\n\n- We... should get out of here.\n\nNot wasting any more time, you help the still-woozy gnome to get out of the ravine and return with her back to the Shaliq.")
		globals.state.sidequests.dolin = 15
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Continue')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['shaliq'] )
	if globals.state.sidequests.dolin == 14:
		outside.maintext.set_bbcode("You take the horny girl and place her small body on your lap, with easy access to her pussy. As you work through her folds in attempt to quickly bring her to orgasm, she turns to embrace you and gives you a sloppy, lustful kiss.\n\n")
		globals.state.sidequests.dolin = 15
		if scout.sexuals.unlocked == true && scout.lust >= 30 :
			outside.maintext.set_bbcode(outside.maintext.get_bbcode() +scout.dictionary("$name, deciding to take part in the fun, gets on her knees and licks all over the poor girl's pussy.\n\n"))
		outside.maintext.set_bbcode(outside.maintext.get_bbcode() + "After few minutes Dolin finally reaches orgasm and regains her senses.\n\n- T-thank you... we should leave this place now.\n\nWithout wasting any more time, you help still-woozy gnome to get out of the ravine and return with her back to the Shaliq.")
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Continue')
		newbutton.set_hidden(false)
		newbutton.connect('pressed', self, 'zoneenter', ['shaliq'] )



func encounterdictionary(text):
	var string = text
	var temp
	temp = str(enemygroup.units.size())
	if temp == '1':
		temp = 'sole'
	string = string.replace('$unitnumber', temp)
	if enemygroup.captured != null:
		temp = str(enemygroup.captured.size())
		if temp == '1':
			temp = 'sole'
		string = string.replace('$capturednumber', temp)
	if enemygroup.units.size() <= 1 &&  enemygroup.units[0].capture != null:
		string = enemygroup.units[0].capture.dictionary(string)
	string = string.replace('$scoutname', scout.name)
	return string

