extends Node

var textnode = load('res://files/scripts/questtext.gd').new()
var emilystate = 0
var outside 
#Mainquests


func gornpalace():
	var text = ''
	var state = true
	var buttons = []
	var sprite = null
	if globals.state.mainquest == 12:
		text = textnode.MainQuestGornPalace
		state = true
		globals.state.mainquest = 13
	elif globals.state.mainquest == 13:
		text = "You decide there's no point to return to Garthor withour bringing Ivran with you. "
	elif globals.state.mainquest == 14:
		text = "Garthor already told you to return tomorrow."
	elif globals.state.mainquest == 15:
		text = textnode.MainQuestGornPalaceReturn
		buttons = [['Execute','gornpalaceivran', 1],['Keep imprisoned','gornpalaceivran', 2],['Leave him to you','gornpalaceivran', 3],['Decide later','gornpalaceivran', 4]]
		state = false
	
	globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)

var ivran

func gornpalaceivran(stage):
	var text
	var state = true
	var buttons = []
	var sprite = null
	
	if stage == 1:
		text = textnode.MainQuestGornIvranExecute + textnode.MainQuestGornAydaSolo
		globals.state.sidequests.ivran = 'killed'
		globals.state.mainquest = 16
		globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('gorn')
	elif stage == 2:
		text = textnode.MainQuestGornIvranImprison + textnode.MainQuestGornAydaSolo
		globals.state.sidequests.ivran = 'imprisoned'
		globals.state.mainquest = 16
		globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('gorn')
	elif stage == 3 && !globals.state.sidequests.ivran in ['tobetaken','tobealtered','potionreceived']:
		text = textnode.MainQuestGornIvranKeep
		globals.state.sidequests.ivran = 'tobetaken'
		globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('gorn')
	elif stage == 3 && globals.state.sidequests.ivran in ['tobetaken','tobealtered']:
		text = "Garthor refuses to give you Ivran as is. You should find his acquaintance. "
	elif stage == 3 && globals.state.sidequests.ivran == 'potionreceived':
		text = textnode.MainQuestGornIvranChange
		globals.state.sidequests.ivran = 'changed'
		globals.state.mainquest = 16
		ivran = globals.slavegen.newslave('Dark Elf', 'adult', 'female', 'rich')
		ivran.name = 'Ivran'
		ivran.surname = ''
		ivran.face.beauty = 75
		ivran.haircolor = 'brown'
		ivran.hairlength = 'shoulder'
		ivran.hairstyle = 'straight'
		ivran.tits.size = 'big'
		ivran.ass = 'average'
		ivran.skin = 'brown'
		ivran.eyecolor = 'amber'
		ivran.pussy.virgin = true
		ivran.pussy.first = 'none'
		ivran.stats.cour_base = 65
		ivran.stats.conf_base = 83
		ivran.stats.wit_base = 55
		ivran.stats.charm_base = 48
		ivran.height = 'tall'
		ivran.loyal = 0
		ivran.obed = 50
		ivran.stress = 60
		ivran.unique = 'Ivran'
		ivran.cleartraits()
		for i in ivran.skills.values():
			i.value = 0
		globals.get_tree().get_current_scene()._on_mansion_pressed()
		buttons = [['Continue','ivranname']]
		state = false
	elif stage == 4:
		globals.get_tree().get_current_scene().close_dialogue()
		return
	
	globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)

func ivranname():
	globals.get_tree().get_current_scene().setname(ivran)
	globals.get_tree().get_current_scene().close_dialogue()
	
	globals.slaves = ivran



func gornivran():
	var text = textnode.MainQuestGornIvranFind
	var sprite
	var buttons = [['Attack','gornivranfight'],['Leave','gornivranleave']]
	globals.get_tree().get_current_scene().get_node("explorationnode").buildenemies("ivranquestenemy")
	globals.get_tree().get_current_scene().dialogue(false, self, text, buttons, sprite)

func gornivranfight():
	globals.get_tree().get_current_scene().close_dialogue()
	globals.get_tree().get_current_scene().get_node("explorationnode").launchonwin = 'gornivranwin'
	globals.get_tree().get_current_scene().get_node("combat").nocaptures = true
	globals.get_tree().get_current_scene().get_node("explorationnode").enemyfight()

func gornivranleave():
	globals.get_tree().get_current_scene().close_dialogue()

func gornivranwin():
	var text 
	var sprite
	var buttons = []
	text = textnode.MainQuestGornIvranWin
	globals.state.sidequests.ivran = ''
	globals.state.upcomingevents.append(({code = 'gornwaitday', duration = 1}))
	globals.state.mainquest = 14
	globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('gorn')
	globals.get_tree().get_current_scene().dialogue(true, self, text, buttons, sprite)

func gornwaitday():
	globals.state.mainquest = 15

func gornayda():
	var text = ''
	var state = true
	var sprite
	var buttons = []
	if globals.state.mainquest == 15 && !globals.state.sidequests.ivran in ['tobealtered','potionreceived']:
		text = textnode.MainQuestGornAydaIvran
		state = false
		buttons = [{name = 'Accept', function = 'gornaydaivran', args = 1}, {name = 'Reject',function = 'gornaydaivran', args = 2}]
	elif globals.state.mainquest == 15 && globals.state.sidequests.ivran == 'tobealtered':
		text = "Ayda asked you to provide her with someone of high magic affinity. "
		buttons = [{name = 'Select', function = 'gornaydaselect'}]
	else:
		if globals.state.sidequests.ayda == 0:
			text = textnode.MainQuestGornAydaFirstMeet
			globals.state.sidequests.ayda = 1
		else:
			text = textnode.GornAydaReturn
		if globals.state.sidequests.ayda == 1:
			buttons.append({name = 'Ask Ayda about herself', function = 'gornaydatalk', args = 1})
		elif globals.state.sidequests.ayda == 2:
			buttons.append({name = 'Ask Ayda about monster races',function = 'gornaydatalk', args =2})
#		elif globals.state.sidequests.ayda >= 3:
#			if globals.resources.gold >= 400:
#				buttons.append({text = "Purchase Elixir of Regression - 400 gold", function = 'gornaydatalk', arguments = 3})
#			else:
#				buttons.append({text = "Purchase Elixir of Regression - 400 gold", function = 'gornaydatalk', arguments = 3, disabled = true, tooltip = "You don't have enough gold"})
		elif globals.state.sidequests.ayda >= 3:
			buttons.append({name = "See Ayda's assortments", function = 'aydashop'})
	if state == true:
		#buttons.append({name = "Continue", function = "gornayda"})
		buttons.append({name = "Leave", function = 'leaveayda'})
	outside.maintext.set_bbcode(globals.player.dictionary(text))
	outside.buildbuttons(buttons, self)
	#globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)

func leaveayda():
	globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('gorn')

func aydashop():
	outside.shopinitiate("aydashop")

func gornaydatalk(stage = 0):
	var text = ''
	var state = true
	var sprite
	var buttons = []
	
	if stage == 1:
		text = textnode.GornAydaTalk
		globals.state.sidequests.ayda = 2
	elif stage == 2:
		text = textnode.GornAydaTalkMonsters
		globals.state.sidequests.ayda = 3
	elif stage == 3:
		text = "[color=green]You have purchased Regression Elixir from Ayda.[/color]"
		globals.resources.gold -= 400
		globals.itemdict.regressionpot.amount += 1
	
	buttons.append({name = "Continue", function = "gornayda"})
	
	outside.maintext.set_bbcode(globals.player.dictionary(text))
	outside.buildbuttons(buttons, self)
	#globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)

func gornaydaselect(slave = null):
	var text
	var state = true
	var sprite
	var buttons = []
	if slave == null:
		globals.get_tree().get_current_scene().selectslavelist(true, 'gornaydaselect', self, 'globals.currentslave.stats.maf_cur >= 4')
	else:
		text = textnode.MainQuestGornAydaIvranReturn
		globals.state.sidequests.ayda = 1
		slave.away.duration = 15
		slave.away.at = 'away'
		globals.state.sidequests.ivran = 'potionreceived'
		buttons.append({name = "Continue", function = "gornayda"})
		outside.maintext.set_bbcode(globals.player.dictionary(text))
		outside.buildbuttons(buttons, self)
		#globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)
	

func gornaydaivran(stage = 0):
	var text
	var sprite
	var buttons = []
	var state = true
	if stage == 0:
		text = textnode.MainQuestGornAydaIvran
		state = false
		buttons = [['Accept','gornaydaivran',1], ['Reject','gornaydainvran',2]]
	elif stage == 1:
		text = textnode.MainQuestGornAydaIvranAccept
		globals.state.sidequests.ivran = 'tobealtered'
	elif stage == 2:
		text = textnode.MainQuestGornAydaIvranReject
	
	buttons.append({name = "Continue", function = "gornayda"})
	outside.maintext.set_bbcode(globals.player.dictionary(text))
	outside.buildbuttons(buttons, self)
	#globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)






#Sidequests

func calievent1():
	var cali = null
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i
	if cali == null:
		globals.state.sidequests.cali = 100
	elif (cali.stress >= 65 && cali.loyal < 25) || cali.obed < 30:
		if cali.sleep == 'jail' || cali.sleep == 'farm' || cali.brand == 'advanced':
			cali.cour = rand_range(5,15)
			cali.conf = rand_range(5,15)
			cali.wit = rand_range(5,15)
			cali.charm = rand_range(5,15)
			globals.get_tree().get_current_scene().dialogue(true,self,'Unable to escape, Cali breaks down by harsh living conditions. It does not seem like she has any interest in looking for her family anymore. ')
			globals.state.sidequests.cali = 101
		else:
			globals.get_tree().get_current_scene().dialogue(true,self,'Unable to bear with your treatment, Cali escaped from mansion.')
			globals.slaves.erase(cali)
			globals.state.sidequests.cali = 100
	else:
		globals.state.sidequests.cali = 13
		return '\n[color=yellow]Cali seems to be concerned about something, maybe you should ask what’s wrong.[/color]'

func calirun():
	var cali = null
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i
	globals.slaves.erase(cali)
	globals.get_tree().get_current_scene().dialogue(true,self,'During the night Cali has escaped from the mansion in unknown direction.')

func calitalk0():
	var sprite = [['calineutral','pos1', 'opac']]
	var text
	var buttons = null
	var cali
	var state = true

	for i in globals.slaves:
		if i.unique == "Cali":
			cali = i

	if globals.state.sidequests.cali == 13:
		cali.tags.append('noescape')
		text = textnode.CaliTalkRequest
		buttons = [['Offer to look into it','calitalk1',1],['Dismiss her concerns','calitalk1',2]]
	elif globals.state.sidequests.cali == 12:
		cali.tags.append('noescape')
		text = textnode.CaliTalkHelp
		globals.state.sidequests.cali = 14
	elif globals.state.sidequests.cali == 22:
		text = textnode.CaliTalk2
		buttons = [['Take her with you','calitalk2',1],['Decline her offer','calitalk2',2]]
	if buttons != null:
		state = false
	
	globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)

func calitalk1(response): # 1 - agree, 2 - refuse
	var sprite
	if response == 1:
		globals.state.sidequests.cali = 14
		sprite = [['calihappy','pos1']]
		for i in globals.slaves:
			if i.unique == 'Cali':
				i.loyal += 10
		globals.get_tree().get_current_scene().dialogue(true,self, textnode.CaliTalkAccept, null, sprite)
	elif response == 2:
		globals.state.sidequests.cali = 100
		sprite = [['calineutral','pos1']]
		globals.get_tree().get_current_scene().dialogue(true,self, textnode.CaliTalkRefuse, null, sprite)
		globals.state.upcomingevents.append({code = 'calirun', duration = 1})

func calitalk2(response): # 1 - accept, 2 - refuse
	var sprite
	if response == 1:
		globals.state.sidequests.cali = 23
		sprite = [['calihappy','pos1']]
		globals.get_tree().get_current_scene().dialogue(true,self, textnode.CaliTalk2Accept, null, sprite)
	elif response == 2:
		sprite = [['calineutral','pos1']]
		globals.state.sidequests.cali = 24
		globals.get_tree().get_current_scene().dialogue(true,self, textnode.CaliTalk2Refuse, null, sprite)

func caliproposal(stage = 0):
	var sprite = [['calineutral','pos1', 'opac']]
	var text
	var buttons = null
	var cali
	var state = true
	print(true)
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i
	if cali == null:
		globals.state.sidequests.cali = 100
		return
	if cali.pussy.virgin == false || cali.loyal <= 50:
		return
	if cali.away.duration != 0:
		globals.state.upcomingevents.append({code = 'caliproposal', duration = cali.away.duration})
	
	if stage == 0:
		text = textnode.CaliProposal
		buttons = [["Accept Cali's feelings",'caliproposal',1],['Stay friends','caliproposal',2]]
		state = false
	elif stage == 1:
		sprite = [['calihappy','pos1']]
		text = textnode.CaliAcceptProposal
		if globals.player.penis.number >= 1:
			cali.pussy.virgin = false
			cali.pussy.first = 'you'
			cali.sexuals.unlocks.append("vaginal")
			cali.metrics.vag += 1
			text += textnode.CaliProposalSexMale
		cali.loyal += 25
		cali.obed += 50
		cali.sexuals.unlocked = true
		cali.metrics.sex += 1
		cali.metrics.orgasm += 1
		cali.metrics.partners.append(globals.player.id)
		cali.unlocksexuals()
	elif stage == 2:
		sprite = [['calineutral','pos1']]
		text = textnode.CaliDenyProposal



	globals.get_tree().get_current_scene().dialogue(state, self, text, buttons, sprite)

func calibar():
	var buttons = []
	var text = ''
	var sprite
	if globals.state.sidequests.cali == 14:
		sprite = [['calineutral','pos1', 'opac']]
		text = textnode.CaliBarEntrance
		globals.state.sidequests.calibarsex = 'none'
		globals.state.sidequests.cali = 15
	elif globals.state.sidequests.cali == 15:
		sprite = [['calineutral','pos1']]
		text = textnode.CaliBarRepeat
	elif globals.state.sidequests.cali == 16:
		sprite = [['calineutral','pos1']]
		text = textnode.CaliBarLastpay
	if !globals.state.sidequests.calibarsex in ['disliked','liked','sebastianfinish'] && globals.resources.gold >= 500:
		buttons.append(['Pay 500 gold for information', 'calibar1', 1])
	if !globals.state.sidequests.calibarsex in ['disliked','liked','agreed','forced','sebastianfinish']:
		buttons.append(['Talk to Cali', 'calibar1', 2])
	if globals.state.sidequests.calibarsex in ['disliked','liked','sebastianfinish'] && globals.resources.gold >= 100:
		buttons.append(['Pay 100 gold for information', 'calibar1', 3])
	if globals.state.sidequests.calibarsex == 'sebastian':
		buttons.append(["Show Jason Sebastian's note", 'calibar1', 9])
	if globals.state.sidequests.calibarsex in ['agreed','forced']:
		buttons.append(['Let him fuck Cali', 'calibar1',5])
	if globals.state.sidequests.cali == 17:
		sprite = [['calineutral','pos1']]
		text = textnode.CaliBarLeave
		globals.get_tree().get_current_scene().dialogue(true, self, text, buttons, sprite)
		return
	buttons.append(['Excuse yourself and leave', 'calibar1', 4])

	globals.get_tree().get_current_scene().dialogue(false,self, text, buttons, sprite)

func calibar1(value):
	var cali = null
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i
	var buttons = []
	var text = ''
	var sprite = [['calineutral','pos1']]
	if value == 1:
		globals.resources.gold -= 500
		text = textnode.CaliBarPay500
		globals.state.sidequests.cali = 17
		buttons.append(['Leave', 'calibar1', 4])
	elif value == 2:
		text = textnode.CaliBarTalk
		buttons.append(["Tell her it's the only way", 'calibar1', 6])
		if globals.state.sidequests.calibarsex != 'reject':
			text += "\n\n[color=yellow]— What? You are not trying to make me... — she cringes — He's disgusting, have you seen how he looks at me?[/color]\n\nCali looks completely repulsed by the whole suggestion, but perhaps you could change her mind. With the right word here and there she may open to the idea."
			buttons.append(["Try talk her into it", 'calibar1', 7])
		else:
			text += "\n\n[color=yellow— I don’t know what to do… Maybe there’s another way?[/color] "
		buttons.append(["Agree and don't press the issue further", 'calibar1', 8])
	elif value == 3:
		globals.resources.gold -= 100
		text = textnode.CaliBarPay100
		globals.state.sidequests.cali = 17
		buttons.append(['Leave', 'calibar1', 4])
	elif value == 4:
		text = textnode.CaliBarLeave
		globals.get_tree().get_current_scene().dialogue(true, self, text, buttons, sprite)
		globals.get_tree().get_current_scene().get_node("outside").backstreets()
		return
	elif value == 5:
		if globals.state.sidequests.calibarsex == 'agreed':
			text = textnode.CaliBarFuckWilling
			globals.state.sidequests.calibarsex = 'liked'
			cali.sexuals.affection += round(rand_range(3,5))
			cali.metrics.sex += 1
			cali.metrics.vag += 1
			cali.metrics.randompartners += 1
			cali.metrics.orgasm += 1
			globals.state.sidequests.cali = 17
			cali.lust -= 15
			cali.loyal -= 5
			cali.energy = -50
			cali.pussy.virgin = false
			cali.add_trait(globals.origins.trait('Fickle'))
		elif globals.state.sidequests.calibarsex == 'forced':
			text = textnode.CaliBarFuckUnwilling
			cali.metrics.sex += 1
			cali.metrics.vag += 1
			cali.metrics.randompartners += 1
			cali.metrics.roughsex += 1
			cali.loyal -= 50
			cali.obed -= 60
			cali.stress += 75
			cali.health = -15
			cali.energy = -50
			cali.pussy.virgin = false
			globals.state.sidequests.calibarsex = 'disliked'
		globals.state.sidequests.cali = 16
		buttons.append(['Continue','calibar'])
	elif value == 6:
		text = textnode.CaliBarForce
		cali.loyal -= 30
		cali.obed -= 30
		globals.state.sidequests.calibarsex = 'forced'
		buttons.append(['Return','calibar'])
	elif value == 7:
		if cali.lust > 50 && cali.sexuals.unlocked == true:
			text = textnode.CaliBarPersuadeSuccess
			globals.state.sidequests.calibarsex = 'agreed'
			buttons.append(['Return','calibar'])
		else:
			text = textnode.CaliBarPersuadeFail
			sprite = [['caliangry','pos1']]
			globals.state.sidequests.calibarsex = 'reject'
			cali.loyal -= 10
			cali.obed -= 15
			buttons.append(['Return','calibar1', 2])
	elif value == 8:
		text = textnode.CaliBarDeny
		buttons.append(['Return','calibar'])
	elif value == 9:
		text = textnode.CaliBarUseSebastian
		globals.state.sidequests.calibarsex = 'sebastianfinish'
		buttons.append(['Return','calibar'])
	globals.get_tree().get_current_scene().dialogue(false, self, text, buttons, sprite)

func calivillage():
	globals.get_tree().get_current_scene().dialogue(true,self,globals.player.dictionaryplayer(textnode.CaliVillageEnter1))
	globals.state.sidequests.cali = 18
	globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('shaliq')

func calivillage2():
	var text = ''
	var buttons = []
	var state = false
	if globals.state.sidequests.cali == 20:
		text = textnode.CaliVillageEnter2
		state = true
	elif globals.state.sidequests.cali == 21:
		text = textnode.CaliVillageEnter3
		buttons.append(['Gratefully accept','calivillage3', 1])
		buttons.append(['Respectfully decline','calivillage3', 2])
	globals.state.sidequests.cali = 22
	globals.get_tree().get_current_scene().dialogue(state,self,text,buttons)

func calivillage3(stage):
	var text = ""
	if stage == 1:
		text = textnode.CaliVillageAcceptReward
		globals.resources.gold += 300
	elif stage == 2:
		text = textnode.CaliVillageRefuseReward
		globals.state.rooms.communal += 2
	globals.get_tree().get_current_scene().dialogue(true,self,text)

var calibanditcampstage = 0 #0 - nothing, 1 - poisoned mead, 2 - dominated, 3 - both

func calibanditcamp():
	var text = ''
	var buttons = []
	if calibanditcampstage == 0:
		text = "You find your way to the Bandit Camp. As you carefully scout out the situation you realize that there’s probably more here than you can easily handle at once.  Two bandits are in the center of the camp arguing over who gets to be to rape the terrified girl tied up near them. Two more are drinking heavily from an open cask of mead, and one more is making a slow circuit of the camp, keeping a close eye on the surrounding woods. "
	elif calibanditcampstage == 1:
		text = "As you carefully scout out the situation you realize that there’s probably more here than you can easily handle at once.  Two bandits are in the center of the camp arguing over who gets to be to rape the terrified girl tied up near them.  Two bandits are lying in a drunken stupor near the mead cask and one more is making a slow circuit of the camp, keeping a close eye on the surrounding woods."
	elif calibanditcampstage == 2:
		text = "As you carefully scout out the situation you realize that there’s probably more here than you can easily handle at once. A bandit is examining the captive girl with interest, while another is trying to bandage up a nasty body wound. Two more are drinking heavily from an open cask of mead, and and the body of a stabbed bandit lies dead near the center of the camp."
	elif calibanditcampstage == 3:
		text = "As you carefully scout out the situation you realize that there’s probably more here than you can easily handle at once. A bandit is examining the captive girl with interest, while another is trying to bandage up a nasty stomach wound. Two bandits are lying in a drunken stupor near the mead cask and the body of a stabbed bandit lies dead near the center of the camp."
	if globals.get_tree().get_current_scene().get_node("explorationnode").scout.wit >= 70 && calibanditcampstage != 1 && calibanditcampstage != 3 && globals.get_tree().get_current_scene().get_node("explorationnode").scout != globals.player:
		buttons.append(["Poison the bandit’s mead", 'calibanditcampaction', 1])
	if globals.spelldict.domination.learned == true && calibanditcampstage != 2 && calibanditcampstage != 3 && globals.spelldict.domination.manacost <= globals.resources.mana:
		buttons.append(["Dominate the wandering sentry", 'calibanditcampaction', 2])
		globals.resources.mana -= globals.spelldict.domination.manacost
	buttons.append(['Attack the camp', 'calibanditcampattack'])
	globals.get_tree().get_current_scene().dialogue(false,self,text,buttons)


func calibanditcampaction(action):
	var buttons = []
	var text = ''
	if action == 1:
		text = textnode.CaliPoisonBandits
		if calibanditcampstage == 2:
			calibanditcampstage = 3
		elif calibanditcampstage == 0:
			calibanditcampstage = 1
	elif action == 2:
		text = textnode.CaliDominateBandits
		if calibanditcampstage == 1:
			calibanditcampstage = 3
		elif calibanditcampstage == 0:
			calibanditcampstage = 2
	buttons.append(['Continue', 'calibanditcamp'])
	globals.get_tree().get_current_scene().dialogue(false,self,text,buttons)


func calibanditcampattack():
	var main = globals.get_tree().get_current_scene()
	var text = "You decide it’s time to attack and charge the camp with your group. "
	if calibanditcampstage == 0:
		main.get_node("explorationnode").buildenemies("banditshard")
	elif calibanditcampstage == 1 || calibanditcampstage == 2:
		main.get_node("explorationnode").buildenemies("banditsmedium")
	elif calibanditcampstage == 3:
		main.get_node("explorationnode").buildenemies("banditseasy")
	var buttons = [["Continue", 'calibanditcampfight']]
	main.dialogue(false,self,text,buttons)

func calibanditcampfight():
	globals.get_tree().get_current_scene().close_dialogue()
	globals.get_tree().get_current_scene().get_node("explorationnode").launchonwin = 'calibanditcampwin'
	globals.get_tree().get_current_scene().get_node("combat").nocaptures = true
	globals.get_tree().get_current_scene().get_node("explorationnode").enemyfight()

func calibanditcampwin():
	var buttons = []
	buttons.append(['Return the girl', 'calibanditcampchoice', 1])
	buttons.append(['Kidnap the girl', 'calibanditcampchoice', 2])
	if globals.spelldict.entrancement.learned == true && globals.spelldict.entrancement.manacost <= globals.resources.mana:
		buttons.append(['Seduce the girl', 'calibanditcampchoice', 3])
		globals.resources.mana -= globals.spelldict.entrancement.manacost
	globals.get_tree().get_current_scene().dialogue(false,self,textnode.CaliBanditCampVictory,buttons)

func calibanditcampchoice(choice):
	var texttemp
	var slave = globals.slavegen.newslave('Human', 'teen', 'female', 'commoner')
	slave.name = 'Tia'
	slave.surname = 'Fallton'
	slave.face.beauty = 75
	slave.haircolor = 'brown'
	slave.hairlength = 'waist'
	slave.hairstyle = 'straight'
	slave.tits.size = 'small'
	slave.ass = 'small'
	slave.skin = 'fair'
	slave.eyecolor = 'blue'
	slave.pussy.virgin = true
	slave.pussy.first = 'none'
	slave.stats.cour_base = 23
	slave.stats.conf_base = 31
	slave.stats.wit_base = 55
	slave.stats.charm_base = 82
	slave.height = 'short'
	slave.cleartraits()
	for i in slave.skills.values():
		i.value = 0
	if choice == 1:
		texttemp = textnode.CaliReturnGirl
		globals.state.sidequests.cali = 21
	elif choice == 2:
		texttemp = textnode.CaliKidnapGirl
		slave.obed += -100
		slave.sleep = 'jail'
		globals.get_tree().get_current_scene().get_node("explorationnode").enemycapture(slave)
		globals.state.sidequests.cali = 20
	elif choice == 3:
		texttemp = textnode.CaliSeduceGirl
		slave.obed += 75
		slave.loyal += 20
		globals.slaves = slave
		globals.state.sidequests.cali = 20
	globals.get_tree().get_current_scene().dialogue(true,self,texttemp)
	globals.get_tree().get_current_scene()._on_mansion_pressed()
	globals.resources.energy = -100

func calislavercamp():
	var cali = null
	var text = ""
	var buttons = []
	var state
	var sprite
	for i in globals.state.playergroup:
		if globals.state.findslave(i).unique == 'Cali':
			cali = globals.state.findslave(i)
	if globals.state.sidequests.cali == 23 && cali == null:
		text = "You said that you would bring Cali along to help, you’ll need her as a companion."
		state = true
	elif globals.state.sidequests.cali == 23:
		text = textnode.CaliSlaversTaken
		state = false
		buttons.append(['Continue', 'calislaver', 1])
		sprite = [['calineutral','pos1','opac']]
	elif globals.state.sidequests.cali == 24:
		text = textnode.CaliSlaversLeft
		state = false
		if globals.resources.gold >= 100:
			buttons.append(['Pay the fee','calislavercamppay',1])
		buttons.append(['Walk away','calislavercamppay',2])
	globals.get_tree().get_current_scene().dialogue(state,self,text, buttons, sprite)



func calislavercamppay(choice):
	var text = ''
	var buttons = []
	var state = true
	if choice == 1:
		globals.resources.gold -= 100
		state = false
		text = textnode.CaliSlaversPay
		buttons.append(['Ask about buying', 'calislaver',2])
		buttons.append(['Attack','calislaver',5])
		globals.get_tree().get_current_scene().dialogue(state, self, text, buttons)
	elif choice == 2:
		globals.get_tree().get_current_scene().close_dialogue()

func calislaver(choice):
	var text = ""
	var buttons = []
	var sprite
	if choice == 1:
		text = textnode.CaliSlaversOffer
		sprite = [['calineutral','pos1']]
		buttons.append(['Sell Cali', 'calislaver',3])
		buttons.append(['Decline','calislaver',4])
		buttons.append(['Attack','calislaver',5])
	elif choice == 2:
		text = textnode.CaliSlaversNoOffer
		buttons.append(['Leave', 'calislaver',6])
	elif choice == 3:
		sprite = [['caliangry','pos1']]
		text = textnode.CaliSlaverSell
		for i in globals.slaves:
			if i.unique == 'Cali':
				globals.slaves.erase(i)
		globals.resources.gold += 350
		buttons.append(['Leave', 'calislaver',7])
	elif choice == 4:
		text = textnode.CaliSlaverNoSell
		buttons.append(['Leave', 'calislaver',6])
	elif choice == 5:
		globals.get_tree().get_current_scene().close_dialogue()
		globals.get_tree().get_current_scene().get_node("explorationnode").buildenemies("CaliBossSlaver")
		globals.get_tree().get_current_scene().get_node("combat").nocaptures = true
		globals.get_tree().get_current_scene().get_node("explorationnode").launchonwin = 'calislaverscampwin'
		globals.get_tree().get_current_scene().get_node("explorationnode").enemyfight()
		return
	elif choice == 6:
		globals.get_tree().get_current_scene().close_dialogue()
		globals.state.sidequests.cali = 25
		globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('wimbornoutskirts')
		return
	elif choice == 7:
		globals.get_tree().get_current_scene().close_dialogue()
		globals.state.sidequests.cali = 100
		globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('wimbornoutskirts')
		return
	globals.get_tree().get_current_scene().dialogue(false, self, text, buttons, sprite)


func calislaverscampwin():
	var cali = null
	var text = ""
	var buttons = []
	var state
	var sprite
	for i in globals.state.playergroup:
		if globals.state.findslave(i).unique == 'Cali':
			cali = globals.state.findslave(i)
	if cali != null:
		sprite = [['calihappy','pos1']]
		text = textnode.CaliSlaversFightWinTogether
	else:
		text = textnode.CaliSlaversFightWinWithout
	globals.state.sidequests.cali = 25
	globals.get_tree().get_current_scene().dialogue(true, self, globals.player.dictionaryplayer(text), null, sprite)
	globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('wimbornoutskirts')


func calistraybandit():
	var cali = null
	var text = ""
	var buttons = []
	var state
	for i in globals.state.playergroup:
		if globals.state.findslave(i).unique == 'Cali':
			cali = globals.state.findslave(i)
	if cali == null:
		globals.get_tree().get_current_scene().popup("You should probably bring Cali along for this, she could confirm if this is in fact the bandit that captured her.")
		return
	globals.get_tree().get_current_scene().close_dialogue()
	globals.get_tree().get_current_scene().get_node("explorationnode").buildenemies("CaliStrayBandit")
	globals.get_tree().get_current_scene().get_node("combat").nocaptures = true
	globals.get_tree().get_current_scene().get_node("explorationnode").launchonwin = 'calistraybanditwin'
	globals.get_tree().get_current_scene().get_node("explorationnode").enemyfight()

func calistraybanditwin():
	var sprite = [['calineutral','pos1','opac']]
	globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('wimbornoutskirts')
	globals.get_tree().get_current_scene().dialogue(true,self,globals.player.dictionaryplayer(textnode.CaliStrayBanditWin), null, sprite)
	globals.state.sidequests.cali = 26
	if globals.state.sidequests.calibarsex in ['none','sebastianfinish']:
		globals.state.upcomingevents.append({code = 'caliproposal', duration = 1})


func calireturnhome():
	var text = ""
	var buttons = []
	var state
	var sprite
	if globals.state.sidequests.caliparentsdead == true:
		text = globals.player.dictionaryplayer(textnode.CaliBadEnd)
		sprite = [['caliangry','pos1','opac']]
		buttons.append(['Let her be','calireturnhome1',1])
		buttons.append(['Comfort her','calireturnhome1',2])
	else:
		text = globals.player.dictionaryplayer(textnode.CaliGoodEnd)
		sprite = [['calihappy','pos1','opac']]
		buttons.append(['Tell them no reward is necessary','caligoodend',1])
		buttons.append(['Tell them anything would be fine','caligoodend',2])
		buttons.append(['Ask if Cali could continue working for you','caligoodend',3])
	globals.get_tree().get_current_scene().dialogue(false,self,text,buttons,sprite)


func calireturnhome1(choice):
	var text = ""
	var buttons = []
	var cali = null
	var sprite = [['calihappy','pos1']]
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i
	if choice == 1:
		text = textnode.CaliBadEndStay
	else:
		text = textnode.CaliBadEndComfort
		cali.loyal += 10
		cali.obed += 20
	buttons.append(['Offer to let her stay with you','calibadend',1])
	buttons.append(['Tell her to be your slave','calibadend',2])
	buttons.append(['Tell her to become your plaything','calibadend',3])
	buttons.append(['Leave her alone','calibadend',4])
	globals.get_tree().get_current_scene().dialogue(false,self,globals.player.dictionaryplayer(text),buttons,sprite)

func calibadend(choice):
	var text = ''
	var cali = null
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i

	var sprite = [['calineutral','pos1']]
	if choice == 1:
		cali.loyal += 100
		cali.conf = -20
		text = textnode.CaliStay
	elif choice == 2:
		text = textnode.CaliSlave
		cali.obed += 100
		cali.conf = -20
	elif choice == 3:
		if cali.loyal >= 50:
			cali.obed += 100
			cali.sexuals.affection = 1000
			for i in ['cour','conf','wit','charm']:
				cali[i] = -100
				cali[i] = rand_range(5,15)
			text = textnode.CaliPlaythingSuccess
		else:
			text = textnode.CaliPlaythingFailure
			globals.resources.gold += 150
			globals.slaves.erase(cali)
			globals.state.playergroup.erase(cali.id)

	elif choice == 4:
		text = textnode.CaliLeave
		globals.state.playergroup.erase(cali.id)
		globals.slaves.erase(cali)
	globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('wimbornoutskirts')
	globals.get_tree().get_current_scene().dialogue(true,self,globals.player.dictionaryplayer(text),null,sprite)
	globals.state.sidequests.cali = 102


func caligoodend(choice):
	var text = ''
	var cali = null
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i
	var sprite = [['calihappy','pos1']]
	if choice == 1:
		text = textnode.CaliGoodEndNoReward
		cali.away.at = 'hidden'
		cali.away.duration = -1
		globals.state.upcomingevents.append({code = 'calireturn', duration = 7})
	elif choice == 2:
		text = textnode.CaliGoodEndReward
		globals.itemdict.hairgrowthpot.amount += 3
		globals.itemdict.stimulantpot.amount += 2
		globals.itemdict.oblivionpot.amount += 1
		globals.itemdict.youthingpot.amount += 1
		globals.slaves.erase(cali)
	elif choice == 3:
		text = textnode.CaliGoodEndKeep
		cali.add_trait(globals.origins.trait('Pliable'))
		cali.loyal += 100
		globals.get_tree().get_current_scene()._on_mansion_pressed()
	if choice != 3:
		globals.get_tree().get_current_scene().get_node("explorationnode").zoneenter('wimbornoutskirts')
	globals.get_tree().get_current_scene().dialogue(true,self,globals.player.dictionaryplayer(text),null,sprite)
	globals.state.sidequests.cali = 103

func calireturn():
	var cali = null
	for i in globals.slaves:
		if i.unique == 'Cali':
			cali = i
	var sprite = [['calihappy','pos1']]
	cali.away.at = 'none'
	cali.away.duration = 0
	cali.add_trait(globals.origins.trait('Clingy'))
	globals.get_tree().get_current_scene().dialogue(true,self,globals.player.dictionaryplayer(textnode.CaliGoodEndNoRewardReturn),null,sprite)
	globals.get_tree().get_current_scene()._on_mansion_pressed()


func caliparentsdie():
	globals.state.sidequests.caliparentsdead = true

func emilymansion(stage = 0):
	var text = ""
	var state = true
	var sprite
	var buttons = []
	var emily
	for i in globals.slaves:
		if i.unique == 'Emily':
			emily = i
	if stage == 0:
		text = textnode.EmilyMansion
		sprite = [['emilyhappy','pos1','opac']]
		state = false
		if globals.itemdict.aphrodisiac.amount > 1:
			buttons.append({text = 'Spike her with aphrodisiac',function = 'emilymansion',arguments = 1})
		else:
			buttons.append({text = 'Spike her with aphrodisiac',function = 'emilymansion',arguments = 1, disabled = true})
		buttons.append({text = 'Assault her after bath', function = 'emilymansion', arguments = 2})
		buttons.append({text = "Just wait", function = "emilymansion", arguments = 3})
	elif stage == 1:
		text = textnode.EmilyShowerSex
		emily.sexuals.unlocked = true
		emily.sexuals.unlocks.append('vaginal')
		emily.sexuals.unlocks.append('petting')
		emily.tags.erase('nosex')
		emily.pussy.virgin = false
		emily.pussy.first = 'you'
		emily.metrics.orgasm += 1
		emily.metrics.vag += 1
		emily.metrics.partners.append(globals.player.id)
		emily.stress += 50
		emily.loyal += 15
		emily.lust += 50
	elif stage == 2:
		text = textnode.EmilyShowerRape
		emily.tags.erase('nosex')
		emily.sexuals.unlocked = true
		emily.stress += 100
		emily.pussy.virgin = false
		emily.pussy.first = 'you'
		emily.metrics.vag += 1
		emily.metrics.partners.append(globals.player.id)
		emily.obed = 0
		globals.state.upcomingevents.append({code = 'emilyescape', duration = 2})
	elif stage == 3:
		text = textnode.EmilyMansion2
		sprite = [['emily2happy','pos1','opac']]
	globals.state.sidequests.emily = 6
	globals.get_tree().get_current_scene().dialogue(state,self,text,buttons,sprite)
	globals.get_tree().get_current_scene()._on_mansion_pressed()

func emilyescape():
	var emily
	for i in globals.slaves:
		if i.unique == 'Emily':
			emily = i
	if emily != null:
		if emily.brand == 'none':
			globals.slaves.erase(emily)
			globals.get_tree().get_current_scene().dialogue(true,self,'During the night Emily has escaped from the mansion in unknown direction.')

func tishaappearance():
	var emily = null
	var buttons = []
	var sprite
	for i in globals.slaves:
		if i.unique == 'Emily':
			emily = i
	if emily == null:
		return
	var text = textnode.TishaEncounter
	sprite = [['emily2normal','pos2','opac2']]
	if emily.loyal >= 25:
		text += textnode.TishaEmilyLoyal
		emilystate = 'loyal'
		buttons.append(['Make Emily leave', 'tishadecision', 1])
		buttons.append(['Make Emily stay', 'tishadecision', 2])
	elif emily.brand != 'none':
		emilystate = 'brand'
		text += textnode.TishaEmilyBranded
		buttons.append(['Release Emily', 'tishadecision', 3])
		buttons.append(['Keep Emily', 'tishadecision', 4])
		buttons.append(['Offer Tisha to take her place', 'tishadecision', 5])
	else:
		text += textnode.TishaEmilyUnloyal
		emilystate = 'unloyal'
		buttons.append(['Let them leave', 'tishadecision', 6])
		buttons.append(['Help them with gold and provision', 'tishadecision', 7])
		buttons.append(['Ask for compensation', 'tishadecision', 8])
	globals.get_tree().get_current_scene().dialogue(false,self,text,buttons,sprite)

func tishadecision(number):
	var emily
	var tisha
	var buttons = []
	for i in globals.slaves:
		if i.unique == 'Emily':
			emily = i
		elif i.unique == 'Tisha':
			tisha = i
	var text = ''
	if number == 1:
		text = textnode.TishaEmilyLeave
		buttons.append(['Let them leave', 'tishadecision', 6])
		buttons.append(['Help them with gold and provision', 'tishadecision', 7])
		globals.get_tree().get_current_scene().dialogue(false,self,text,buttons)
	elif number == 2:
		text = textnode.TishaEmilyStay
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)
	elif number == 3:
		globals.slaves.erase(emily)
		text = textnode.TishaEmilyLeaveFree
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)
	elif number == 4:
		text = "You send Tisha off as you hold all the rights over Emily now. Having no choice, she curses you and leaves. "
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)
	elif number == 5:
		text = textnode.TishaEmilyBrandCompensation
		buttons.append(['Go with your word and release Emily', 'tishadecision', 10])
		buttons.append(['Keep Emily anyway', 'tishadecision', 9])
		text += "\n\n[color=green]You've earned 15 mana.\n\nTisha now belongs to you. [/color]"
		globals.resources.mana += 15
		globals.get_tree().get_current_scene().dialogue(false,self,text,buttons)
		var slave = maketisha()
		globals.slaves = slave
	elif number == 6:
		text = textnode.TishaEmilyLeaveFree
		if emilystate == 'loyal':
			emily.away.at = 'hidden'
			emily.away.duration = -1
			emily.obed += -20
			globals.state.upcomingevents.append({code = 'emilyreturn', duration = 5})
			globals.state.sidequests.emily = 10
		else:
			globals.slaves.erase(emily)
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)
	elif number == 7:
		text = textnode.TishaEmilyLeaveHelp
		emily.away.at = 'hidden'
		emily.away.duration = -1
		emily.loyal += 15
		globals.state.upcomingevents.append({code = 'emilyreturn', duration = 5})
		globals.resources.food -= 50
		globals.resources.gold -= 50
		globals.state.reputation.wimborn += 5
		globals.state.sidequests.emily = 11
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)
	elif number == 8:
		text = textnode.TishaEmilyCompensation
		text += "\n\n[color=green]You've earned 15 mana. [/color]"
		globals.slaves.erase(emily)
		globals.resources.mana += 15
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)
	elif number == 9:
		text = textnode.TishaEmilyKeepEmily
		emily.loyal += -100
		emily.obed += -50
		tisha.obed += -75
		var effect = globals.effectdict.captured
		effect.duration = 15
		globals.state.reputation.wimborn -= 20
		emily.add_effect(effect)
		tisha.add_effect(effect)
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)
	elif number == 10:
		text = textnode.TishaEmilyReleaseEmily
		globals.state.reputation.wimborn -= 10
		tisha.obed += 50
		globals.slaves.erase(emily)
		globals.get_tree().get_current_scene().dialogue(true,self,text,buttons)

func maketisha():
	var slave = globals.slavegen.newslave('Human', 'teen', 'female', 'commoner')
	slave.name = 'Tisha'
	slave.surname = 'Hale'
	slave.unique = 'Tisha'
	slave.face.beauty = 80
	slave.haircolor = 'auburn'
	slave.hairlength = 'waist'
	slave.hairstyle = 'braid'
	slave.tits.size = 'big'
	slave.ass = 'average'
	slave.skin = 'fair'
	slave.eyecolor = 'gray'
	slave.pussy.virgin = false
	slave.pussy.first = 'unknown'
	slave.stats.cour_base = 65
	slave.stats.conf_base = 58
	slave.stats.wit_base = 39
	slave.stats.charm_base = 71
	slave.height = 'average'
	slave.relatives.father = -1
	slave.relatives.mother = 2
	slave.cleartraits()
	return slave


func emilyreturn():
	var emily
	var sprite = [['emily2happy','pos1','opac']]
	for i in globals.slaves:
		if i.unique == 'Emily':
			emily = i
	emily.away.at = 'none'
	emily.away.duration = 0
	var text = textnode.EmilyReturn
	if globals.state.sidequests.emily == 10:
		text += "Tisha probably thinks you are not a bad person after all."
	else:
		text += "I think she was really surprised that you still helped us, even with her being angry and taking me away… "
	text += "If I can, can I still stay at your place, $master?[/color]\n\nYou welcome Emily back and she excuses herself, returning to her previous duties. "
	emily.loyal += 10
	emily.obed += 80
	globals.state.upcomingevents.append({code = 'tishadisappear', duration = round(rand_range(9,14))})
	globals.get_tree().get_current_scene().dialogue(true,self,globals.player.dictionaryplayer(text), null, sprite)
	globals.get_tree().get_current_scene()._on_mansion_pressed()


func tishadisappear(stage = 0):
	var emily
	var buttons = []
	var sprite
	var text = ""
	var state = false
	for i in globals.slaves:
		if i.unique == 'Emily':
			emily = i
	if emily == null:
		return
	if stage == 0:
		sprite = [['emily2worried','pos1','opac']]
		text = textnode.EmilyTishaDisappear
		buttons.append(['Agree to help', 'tishadisappear', 1])
		buttons.append(['Deny', 'tishadisappear', 2])
		buttons.append(['Ask for additional service', 'tishadisappear', 3])
	if stage == 1:
		sprite = [['emily2happy','pos1']]
		text = textnode.TishaDisappearAgree
		globals.state.sidequests.emily = 12
		emily.loyal += 15
		emily.obed += 20
		state = true
	elif stage == 2:
		sprite = [['emily2worried','pos1']]
		text = textnode.TishaDisappearDeny
		globals.state.sidequests.emily = 100
		emily.obed += -30
		emily.loyal += -20
		emily.stress += 40
		state = true
	elif stage == 3:
		sprite = [['emily2worried','pos1']]
		text = textnode.TishaDisappearUnlock
		globals.state.sidequests.emily = 12
		emily.loyal += -10
		emily.sexuals.unlocked = true
		emily.tags.erase('nosex')
		state = true
	globals.get_tree().get_current_scene().dialogue(state,self,text,buttons,sprite)
	globals.get_tree().get_current_scene()._on_mansion_pressed()

func tishadorms(stage=0):
	var emily
	var buttons = []
	var text = ""
	var state = false
	var sprite = null

	for i in globals.state.playergroup:
		if globals.state.findslave(i).unique == 'Emily':
			emily = globals.state.findslave(i)
	if stage == 0:
		text = textnode.TishaVisitArchives
		state = true
		buttons.append(['Move to Dorms', 'tishadorms', 1])
	if stage == 1:
		text = textnode.TishaDorms
		if emily != null:
			sprite = [['emily2worried','pos1']]
			text += textnode.TishaDormsEmilyPresent
			text += textnode.TishaDormsInfo
			globals.state.sidequests.emily = 13
			state = true
		else:
			if globals.spelldict.domination.learned == true && globals.spelldict.domination.manacost <= globals.resources.mana:
				buttons.append(['Cast Domination', 'tishadorms', 2])
			buttons.append(['Threaten', 'tishadorms', 3])
			if globals.resources.gold >= 50:
				buttons.append(['Bribe', 'tishadorms', 4])
	elif stage == 2:
		globals.resources.mana -= globals.spelldict.domination.manacost
		text = textnode.TishaDormsDominate
		text += textnode.TishaDormsInfo
		state = true
	elif stage == 3:
		text = textnode.TishaDormsThreat
		text += textnode.TishaDormsInfo
		state = true
	elif stage == 4:
		globals.resources.gold -= 50
		text = textnode.TishaDormsBribe
		text += textnode.TishaDormsInfo
		state = true
	if stage >= 2:
		globals.state.sidequests.emily = 13
		globals.get_tree().get_current_scene().get_node("outside").mageorder()
	globals.get_tree().get_current_scene().dialogue(state,self,text,buttons)

func tishabackstreets(stage = 0):
	var emily
	var buttons = []
	var text = ""
	var state = false
	var main = globals.get_tree().get_current_scene()

	if stage == 0:
		text = textnode.TishaBackstreets
		buttons.append(['Fight', 'tishabackstreets', 1])
		buttons.append(['Leave', 'tishabackstreets', 2])
	elif stage == 1:
		main.get_node("explorationnode").buildenemies("tishaquestenemy")
		globals.get_tree().get_current_scene().close_dialogue()
		globals.get_tree().get_current_scene().get_node("explorationnode").launchonwin = 'tishabackstreetswin'
		globals.get_tree().get_current_scene().get_node("combat").nocaptures = true
		globals.get_tree().get_current_scene().get_node("explorationnode").enemyfight()
		return
	elif stage == 2:
		main.close_dialogue()
		globals.get_tree().get_current_scene().get_node("outside").backstreets()
		return

	globals.get_tree().get_current_scene().dialogue(state,self,text,buttons)

func tishabackstreetswin():
	var text = ""
	globals.state.sidequests.emily = 14
	text = textnode.TishaBackstreetsAftercombat
	globals.get_tree().get_current_scene().dialogue(true,self,text)
	globals.get_tree().get_current_scene().get_node("outside").backstreets()

func tishagornguild(stage = 0):
	var buttons = []
	var text = ""
	var state = false

	if stage == 0:
		if globals.state.sidequests.emily == 14:
			text = textnode.TishaGornGuild
			globals.state.sidequests.emily = 15
		else:
			text = textnode.TishaGornGuildRevisit
		buttons.append(['Pay', 'tishagornguild', 1])
		buttons.append(['Leave', 'tishagornguild', 2])
	elif stage == 1:
		text = textnode.TishaGornPay
		globals.resources.gold -= 500
		buttons.append(['Brand', 'tishagornguild', 3])
		buttons.append(['Refuse', 'tishagornguild', 4])
	elif stage == 2:
		globals.get_tree().get_current_scene().close_dialogue()
		globals.get_tree().get_current_scene().get_node("outside").slaveguild('gorn')
		return
	elif stage == 3:
		text = textnode.TishaGornBrand
		globals.state.sidequests.emily = 101
		var slave = maketisha()
		slave.brand = 'basic'
		globals.slaves = slave
		state = true
		globals.get_tree().get_current_scene().get_node("outside").slaveguild('gorn')
	elif stage == 4:
		text = textnode.TishaGornRefuseBrand
		buttons.append(['Continue', 'tishagornguild', 5])
	elif stage == 5:
		globals.get_tree().get_current_scene()._on_mansion_pressed()
		if OS.get_name() != "HTML5" && globals.rules.fadinganimation == true:
			yield(globals.get_tree().get_current_scene(), 'animfinished')
		text = textnode.TishaAfterGorn
		buttons.append(['Ask for money', 'tishagornguild', 6])
		buttons.append(['Have sex', 'tishagornguild', 7])
		buttons.append(["Don't ask for anything", 'tishagornguild', 8])
	elif stage == 6:
		text = textnode.TishaAskPayment
		globals.state.sidequests.emily = 17
		globals.state.upcomingevents.append({code = "tishapay", duration = 7})
		state = true
	elif stage == 7:
		text = textnode.TishaSexSceneStart
		if globals.player.penis.number > 0:
			text += "\n\n" + textnode.TishaSexSceneEnd
		globals.resources.mana += 10
		buttons.append(['Offer Tisha work for you', 'tishagornguild', 9])
		buttons.append(['Not bother her', 'tishagornguild', 10])
	elif stage == 8:
		text = textnode.TishaRefusePayment + textnode.TishaSexSceneStart
		globals.resources.mana += 10
		if globals.player.penis.number > 0:
			text += "\n\n" + textnode.TishaSexSceneEnd
		buttons.append(['Offer Tisha work for you', 'tishagornguild', 9])
		buttons.append(['Not bother her', 'tishagornguild', 10])
	elif stage == 9:
		for i in globals.slaves:
			if i.unique == "Emily":
				i.tags.erase('nosex')
		text = textnode.TishaOfferJob
		var slave = maketisha()
		slave.sexuals.unlocked = true
		slave.sexuals.unlocks.append('petting')
		slave.sexuals.unlocks.append('oral')
		slave.sexuals.unlocks.append('vaginal')
		slave.unlocksexuals()
		slave.obed += 90
		slave.loyal += 15
		globals.slaves = slave
		state = true
		globals.state.sidequests.emily = 16
		for i in globals.slaves:
			if i.unique == 'Emily':
				i.sexuals.unlocked = true
				i.tags.erase("nosex")
	elif stage == 10:
		for i in globals.slaves:
			if i.unique == "Emily":
				i.tags.erase('nosex')
		text = textnode.TishaLeave
		state = true
		globals.state.sidequests.emily = 16

	globals.get_tree().get_current_scene().dialogue(state,self,text,buttons)

func tishapay():
	var text = "At the morning you receive a delivery: nice sum of gold from Tisha, who you helped previously. "
	globals.resources.gold += 500
	globals.get_tree().get_current_scene().popup(text)

