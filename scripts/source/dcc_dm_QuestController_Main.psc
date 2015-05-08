Scriptname dcc_dm_QuestController_Main extends Quest
{The main controller interface for working with Display Model. Point a property
at this to use the API.}

;; accessing Display Model as an object property...
;; dcc_dm_QuestController_Main Property DM Auto

;/******************************************************************************
		________  .__               .__
		\______ \ |__| ____________ |  | _____  ___.__.
		 |    |  \|  |/  ___/\____ \|  | \__  \<   |  |
		 |    `   \  |\___ \ |  |_> >  |__/ __ \\___  |
		/_______  /__/____  >|   __/|____(____  / ____|
		        \/        \/ |__|             \/\/
		   _____             .___     .__    ________
		  /     \   ____   __| _/____ |  |   \_____  \
		 /  \ /  \ /  _ \ / __ |/ __ \|  |    /  ____/
		/    Y    (  <_> ) /_/ \  ___/|  |__ /       \
		\____|__  /\____/\____ |\___  >____/ \_______ \
		        \/            \/    \/               \/
******************************************************************************/;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BEHAVIOUR API;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; control how an actor behaves via package overrides. this will be mostly used
;; to make actors stand still and do nothing, as well as release them from that
;; boring life. by default applying our special do nothing package will be auto
;; priority'd to 99, and anything else 100. when removing the non-donothing will
;; then allow the actor to fall back into doing nothing until released.

;; Void BehaviourApply(Actor who, Package what, Int priority=-1)
;; Void BehaviourClear(Actor who, Package what)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLONE API ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The main purpose of the clone API is to give you a super easy way to create
;; basically, mannequins. You can create a copy of yourself, it will be given
;; only the gear you currently have equipped, and it will be told to do nothing.
;; You now have a means to spawn infinite mannequins that look like anybody.
;; Add some bondage (Zaz Animation Pack (which this mod will also expose)) and
;; the anal torch and now you have a mannequin lamp you can spawn infinite of
;; to light up your house.

;; Void            CloneActorClear(Actor clipboard)
;; Void            CloneActorCopy(Actor clipboard, Actor source)
;; Actor           CloneActorGet(Actor clipboard)
;; Actor           CloneActorPaste(Actor clipboard)
;; ObjectReference CloneMarkerPlace(Actor who)
;; ObjectReference CloneMarkerSet(Actor who, ObjectReference where)
;; ObjectReference CloneMarkerGet(Actor who)
;; Void            CloneMarkerClear(Actor who)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STORAGE UTIL KEYS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;
;; Actor ;;;;;;;;;;;;;;;

;; String          DisplayModel.Actor.Animation
;; Form            DisplayModel.Actor.OutfitNormal
;; Form            DisplayModel.Actor.OutfitSleep
;; Actor           DisplayModel.Clone.Actor
;; ObjectReference DisplayModel.Clone.Marker


;;;;;;;;;;;;;;;;;;;;;;;;
;; Package ;;;;;;;;;;;;;

;; Actor[]         DisplayModel.Package.Users

;/******************************************************************************
  _   __          _ ____       ___                        __  _
 | | / /__ ____  (_) / /__ _  / _ \_______  ___  ___ ____/ /_(_)__ ___
 | |/ / _ `/ _ \/ / / / _ `/ / ___/ __/ _ \/ _ \/ -_) __/ __/ / -_|_-<
 |___/\_,_/_//_/_/_/_/\_,_/ /_/  /_/  \___/ .__/\__/_/  \__/_/\__/___/
                                         /_/
******************************************************************************/;

Actor Property Player Auto
Static Property StaticX Auto

;/******************************************************************************
   ___  __  ______    ___                        __  _
  / _ \/  |/  /_  |  / _ \_______  ___  ___ ____/ /_(_)__ ___
 / // / /|_/ / __/  / ___/ __/ _ \/ _ \/ -_) __/ __/ / -_|_-<
/____/_/  /_/____/ /_/  /_/  \___/ .__/\__/_/  \__/_/\__/___/
                                /_/
******************************************************************************/;

;; behaviour packages.
Package Property dcc_dm_PackageDoNothing Auto

;; interface spells.
Spell Property dcc_dm_SpellCloneMenuShow Auto

;/******************************************************************************
  _____          ____                    __  _
 / ___/__  ___  / _(_)__ ___ _________ _/ /_(_)__  ___  ___
/ /__/ _ \/ _ \/ _/ / _ `/ // / __/ _ `/ __/ / _ \/ _ \(_-<
\___/\___/_//_/_//_/\_, /\_,_/_/  \_,_/\__/_/\___/_//_/___/
                   /___/
******************************************************************************/;

Bool Property OptDebug = False Auto Hidden

;/******************************************************************************
  __  ____  _ ___ __         __  ___    __  __           __
 / / / / /_(_) (_) /___ __  /  |/  /__ / /_/ /  ___  ___/ /__
/ /_/ / __/ / / / __/ // / / /|_/ / -_) __/ _ \/ _ \/ _  (_-<
\____/\__/_/_/_/\__/\_, / /_/  /_/\__/\__/_//_/\___/\_,_/___/
                   /___/
******************************************************************************/;

dcc_dm_QuestController_Main Function Get() global
{fetch the quest controller instance. this idea was more of a thought experiment
about attempting to lessen save and index bloat by not defining any properties
in spell effects to the main quest. i am leaving it here though because it might
make dealing with dialog fragments a little easier.}

	Return Game.GetFormFromFile(0xd62,"dc-display-model-2.esp") as dcc_dm_QuestController_Main
EndFunction

Function Print(String msg)
{print messages out to the notification area.}

	Debug.Notification("[DM2] " + msg);
	Return
EndFunction

Function PrintDebug(string msg)
{print messages out to the notification area if debugging is enabled.}

	If(!self.OptDebug)
		Return
	EndIf

	Debug.Notification("[DM2-DBG] " + msg)
	Return
EndFunction

Function WheelMenuSet(Int num, String text, String tip, Bool enabled=True)
{assign things to wheel menu positions.}

	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",num,text)
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",num,tip)
	UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",num,enabled)

	Return
EndFunction

Function EquipStoredArmor(Actor who, Bool strip=True)
{equip the items stored for this actor.}

	Form item
	Int icount = StorageUtil.FormListCount(who,"DisplayModel.Clone.ArmorList")

	If(strip)
		who.RemoveAllItems()
	EndIf

	While(icount)
		icount -= 1
		item = StorageUtil.FormListGet(who,"DisplayModel.Clone.ArmorList",icount)

		If(item != None)
			who.EquipItem(item)
		EndIf
	EndWhile

	Return
EndFunction

Function StoreEquippedArmor(Actor who, Actor dest=None)
{store a list of the items the specified actor is wearing. if a second actor is
specified then the list is stored under that actor instead, copying from the
source.}

	Form item
	Int icount = who.GetNumItems()

	If(dest == None)
		dest = who
	EndIf

	StorageUtil.FormListClear(dest,"DisplayModel.Clone.ArmorList")

	While(icount)
		icount -= 1
		item = who.GetNthForm(icount)

		If(who.IsEquipped(item))
			If(item as ObjectReference != None)
				StorageUtil.FormListAdd(dest,"DisplayModel.Clone.ArmorList",(item as ObjectReference).GetBaseObject())
			Else
				StorageUtil.FormListAdd(dest,"DisplayModel.Clone.ArmorList",item)
			EndIf
		EndIf
	EndWhile

	Return
EndFunction


;/******************************************************************************
   __  ___        __  ____    __
  /  |/  /__  ___/ / / __/__ / /___ _____
 / /|_/ / _ \/ _  / _\ \/ -_) __/ // / _ \
/_/  /_/\___/\_,_/ /___/\__/\__/\_,_/ .__/
                                   /_/
******************************************************************************/;

Event OnInit()
;; handle mod setup.

	self.ResetModValues()
	self.ResetModSpells()

	Return
EndEvent

Function ResetMod()
;; reset all the things.

	self.Reset()
	self.Stop()
	self.Start()
	self.ResetModValues()
	self.ResetModSpells()

	Return
EndFunction

Function ResetModValues()
;; reset all the config options to their defaults.

	self.OptDebug = False

	self.UnregisterForMenu("Sleep/Wait Menu")
	self.RegisterForMenu("Sleep/Wait Menu")

	Return
EndFunction

Function ResetModSpells()
;; reset the player's spells.

	;; remove everything from the player.
	self.Player.RemoveSpell(self.dcc_dm_SpellCloneMenuShow)

	;; add back the starting spells.
	self.Player.AddSpell(self.dcc_dm_SpellCloneMenuShow,True)

	Return
EndFunction

Event OnMenuOpen(String Menu)
{watch for menus.}

	If(Menu == "Sleep/Wait Menu")
		self.OnWaitMenu(true)
	EndIf

	Return
EndEvent

Event OnMenuClose(String Menu)
{watch for menus.}

	If(Menu == "Sleep/Wait Menu")
		self.OnWaitMenu(false)
	EndIf

	Return
EndEvent

;/******************************************************************************
******************************************************************************/;

Function OnWaitMenu(Bool opened)
{when we sleep or wait, we want to try and disable any npc running the do
nothing package to prevent them from moving while we wait. it seems package
processing is suspended during wait and there is actually a moment they may get
a step or two away before kicking in again.}

	Int num = StorageUtil.FormListCount(self.dcc_dm_PackageDoNothing,"DisplayModel.Package.Users")
	Actor who

	While(num > 0)
		num -= 1
		who = StorageUtil.FormListGet(self.dcc_dm_PackageDoNothing,"DisplayModel.Package.Users",num) as Actor

		If(who != None)
			If(opened)
				who.Disable(false)
			Else
				who.Enable(false)
			EndIf
		EndIf
	EndWhile

	Return
EndFunction

;/******************************************************************************
******************************************************************************/;

Function AnimationApply(Actor who, String which)
{play and store an animation that can be renewed later.}

	self.AnimationSet(who,which)
	Debug.SendAnimationEvent(who,which)
	Return
EndFunction

String Function AnimationGet(Actor who)
{return the animation that was stored for this actor.}

	If(StorageUtil.HasStringValue(who,"DisplayModel.Actor.Animation"))
		Return StorageUtil.GetStringValue(who,"DisplayModel.Actor.Animation")
	Else
		Return "IdleForceDefaultState"
	Endif
EndFunction

Function AnimationSet(Actor who, String which)
{store an animation for an actor.}

	StorageUtil.SetStringValue(who,"DisplayModel.Actor.Animation",which)
	Return
EndFunction

Function AnimationRenew(Actor who)
{replay the stored animation for an actor.}

	Debug.SendAnimationEvent(who,self.AnimationGet(who))
	Return
EndFunction

;;;;;;;;
;;;;;;;;

Function SightEventRegister(Actor who)
;; register for los gains. when we gain sight on an actor that is being told to
;; display we will check to make sure it is still doing the last animation they
;; were told to do.

	self.RegisterForLOS(self.Player,who)
	Return
EndFunction

Function SightEventUnregister(Actor who)
;; unregister for los gains.

	self.UnregisterForLOS(self.Player,who)
	Return
EndFunction

Event OnGainLOS(Actor who, ObjectReference target)

	;; if the player sees a display model make sure they are still animating
	;; properly. mostly for things like cell changes.
	If((target as Actor).GetCurrentPackage() == self.dcc_dm_PackageDoNothing)
		self.AnimationRenew(target as Actor)
	EndIf

	Return
EndEvent

;/******************************************************************************
   ___      __             _                 ___   ___  ____
  / _ )___ / /  ___ __  __(_)__  __ ______  / _ | / _ \/  _/
 / _  / -_) _ \/ _ `/ |/ / / _ \/ // / __/ / __ |/ ___// /
/____/\__/_//_/\_,_/|___/_/\___/\_,_/_/   /_/ |_/_/  /___/

******************************************************************************/;

Function BehaviourApply(Actor who, Package what, Int priority=-1)
;; apply the specified ai behaviour package to the specified actor. if priority
;; is omitted or -1, then this function will automatically decide what priority
;; to use based on how this mod operates. this mod also applies the update
;; registration hack to prevent unnamed actors from being recycled by the game
;; engine if the package being applied is the display model base nothing
;; package.

	If(priority == -1)
		;; auto determine what priority.
		If(what == self.dcc_dm_PackageDoNothing)
			priority = 99
		Else
			priority = 100
		EndIf
	ElseIf(priority > 100)
		;; fix out of bounds priority.
		priority = 100
	ElseIf(priority < 0)
		;; fix out of bounds priority.
		priority = 1
	EndIf

	If(what == self.dcc_dm_PackageDoNothing)
		who.RegisterForUpdate(60)
		who.SetRestrained(True)
		who.SetDontMove(True)
		self.AnimationApply(who,"ZazAPC001")
		self.SightEventRegister(who)
		self.OutfitApply(who,None)
		self.OutfitApply(who,None,true)
	EndIf

	ActorUtil.AddPackageOverride(who,what,priority)
	who.EvaluatePackage()

	StorageUtil.FormListAdd(what,"DisplayModel.Package.Users",who)

	Return
EndFunction

Function BehaviourClear(Actor who, Package what)
;; remove the specified package from the overrides of the specified actor. it
;; will also clear the update registration hack if the package being removed
;; is the display model base nothing package.

	ActorUtil.RemovePackageOverride(who,what)
	who.EvaluatePackage()

	If(what == self.dcc_dm_PackageDoNothing)
		who.UnregisterForUpdate()
		who.SetRestrained(False)
		who.SetDontMove(False)
		self.SightEventUnregister(who)
		self.OutfitRestore(who)
	EndIf

	StorageUtil.FormListRemove(what,"DisplayModel.Package.Users",who,True)

	Return
EndFunction

;/******************************************************************************
  ____       __  ____ __    ___   ___  ____
 / __ \__ __/ /_/ _(_) /_  / _ | / _ \/  _/
/ /_/ / // / __/ _/ / __/ / __ |/ ___// /
\____/\_,_/\__/_//_/\__/ /_/ |_/_/  /___/

******************************************************************************/;

Function OutfitApply(Actor who, Outfit what, Bool sleep=false)
{Set an outfit for a specified actor. if it is the first time used on the actor
then it will mark down what the original outfit was so that it can be restored
later.}

	If(StorageUtil.GetFormValue(who,"DisplayModel.Actor.OutfitNormal") == None)
		StorageUtil.SetFormValue(who,"DisplayModel.Actor.OutfitNormal",who.GetActorBase().GetOutfit(false))
		StorageUtil.SetFormValue(who,"DisplayModel.Actor.OutfitSleep",who.GetActorBase().GetOutfit(true))
	EndIf

	who.SetOutfit(what,sleep)

	Return
EndFunction

Function OutfitRestore(Actor who)
{restore an outfit that was stored for the specified actor, if it had been
saved previously.}

	who.SetOutfit(StorageUtil.GetFormValue(who,"DisplayModel.Actor.OutfitNormal") as Outfit, false)
	who.SetOutfit(StorageUtil.GetFormValue(who,"DisplayModel.Actor.OutfitSleep") as Outfit, true)

	Return
EndFunction


;/******************************************************************************
  _______                    ___   ___  ____
 / ___/ /__  ___  ___ ____  / _ | / _ \/  _/
/ /__/ / _ \/ _ \/ -_) __/ / __ |/ ___// /
\___/_/\___/_//_/\__/_/   /_/ |_/_/  /___/

******************************************************************************/;

Function CloneMenuShow()
{Show the cloner menu.}

	Actor target = Game.GetCurrentCrosshairRef() as Actor
	Bool targetenable
	String targetlabel
	bool cloneenable
	string clonelabel
	Int result

	If(target != None)
		targetenable = True
		targetlabel = "Target " + target.GetDisplayName()
	Else
		targetenable = False
		targetlabel = "[No Target]"
	EndIf

	If(self.CloneActorGet(self.Player) != None)
		cloneenable = True
		clonelabel = "Spawn " + self.CloneActorGet(self.Player).GetDisplayName()
	Else
		cloneenable = False
		clonelabel = "[No Source Selected]"
	EndIf

	UIExtensions.InitMenu("UIWheelMenu")
	self.WheelMenuSet(0,targetlabel,"Mark the target for cloning.",targetenable)
	self.WheelMenuSet(1,"Target Self","Mark yourself for cloning.",True)
	self.WheelMenuSet(4,"Set Location","Mark your spot and angle for spawning the next clone.",True)
	self.WheelMenuSet(7,clonelabel,"Spawn a clone at the specified location.",cloneenable)
	result = UIExtensions.OpenMenu("UIWheelMenu")

	If(result == 0)
		self.CloneActorCopy(self.Player,target)
	ElseIf(result == 1)
		self.CloneActorCopy(self.Player,self.Player)
	ElseIf(result == 4)
		self.CloneMarkerPlace(self.Player)
	ElseIf(result == 7)
		self.CloneActorPaste(self.Player)
	EndIf

	Return
EndFunction

Function CloneMarkerClear(Actor who)
{Clear the location saved for clone spawning.}

	ObjectReference loc = self.CloneMarkerGet(who)

	If(loc != None)
		loc.Delete()
	EndIf

	StorageUtil.UnsetFormValue(who,"DisplayModel.Clone.Marker")

	If(who == self.Player)
		self.Print("Your clone location has been cleared.")
	EndIf

	Return
EndFunction

ObjectReference Function CloneMarkerGet(Actor who)
{Fetch a location we previously jotted down.}

	Return StorageUtil.GetFormValue(who,"DisplayModel.Clone.Marker") as ObjectReference
EndFunction

ObjectReference Function CloneMarkerPlace(Actor who)
{place a marker in the world where clones will be pasted to. this is derived
from the casters location and angle. stand where you want the actor to be and
the direction you want them to face prior to using this. each actor can place
their own paste marker. for i don't know, if some reason skyrim becomes
multiplayer tomorrow or someshit. this marker will also be returned as well as
stored in storage util.}

	ObjectReference loc

	loc = self.CloneMarkerGet(who)
	If(loc != None)
		loc.Delete()
	EndIf

	loc = who.PlaceAtMe(self.StaticX,1,True,False)
	self.CloneMarkerSet(who,loc)

	Return loc
EndFunction

Function CloneMarkerSet(Actor who, ObjectReference what)
{Jot down a location where we want clones to spawn. You can use this to define
a location which was not created by CloneMarkerPlace.}

	StorageUtil.SetFormValue(who,"DisplayModel.Clone.Marker",what)

	If(who == self.Player)
		self.Print("Your clone location has been set.")
	EndIf

	Return
EndFunction

;;;;;;;;
;;;;;;;;

Function CloneActorClear(Actor who)
{Clear the saved actor.}

	StorageUtil.UnsetFormValue(who,"DisplayModel.Clone.Actor")

	If(who == self.Player)
		self.Print("Your clone tool has been cleared.")
	EndIf

	Return
EndFunction

Function CloneActorCopy(Actor who, Actor source)
{Save an actor we want to copy.}

	StorageUtil.SetFormValue(who,"DisplayModel.Clone.Actor",source)

	If(who == self.Player)
		self.Print(source.GetDisplayName() + " has been marked for cloning.")
	EndIf

	Return
EndFunction

Actor Function CloneActorGet(Actor who)
{Fetch the actor we wanted to clone.}

	Return StorageUtil.GetFormValue(who,"DisplayModel.Clone.Actor") as Actor
EndFunction

Actor Function CloneActorPaste(Actor who)
{Place a new actor in the world that is a copy of our source.}

	Actor source = self.CloneActorGet(who)
	ObjectReference loc = self.CloneMarkerGet(who)

	;; make sure we had an actor.
	If(source == None)
		If(who == self.Player)
			self.Print("You have not selected any actors for cloning.")
		EndIf
		Return None
	EndIf

	;; make sure we had a drop point. if not, drop one.
	If(loc == None)
		loc = self.CloneMarkerPlace(who)
	EndIf

	;;;;;;;;
	;;;;;;;;

	;; place a new object at our location.
	Actor clone = loc.PlaceAtMe(source.GetActorBase(),1,True,False) as Actor
	If(clone == None)
		self.Print("Creating a clone fucked up for some reason.")
		Return None
	EndIf

	;; stand there like a tool doing nothing with nothing.
	self.BehaviourApply(clone,self.dcc_dm_PackageDoNothing)
	clone.RemoveAllItems()

	;; and copy the source armor.
	self.StoreEquippedArmor(who,clone)
	self.EquipStoredArmor(clone)

	Return clone
EndFunction

