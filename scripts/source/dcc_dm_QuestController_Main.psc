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
;; FormList        DisplayModel.Actor.ArmorList


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

;; various
Outfit Property dcc_dm_OutfitNone Auto

;/******************************************************************************
  _____          ____                    __  _
 / ___/__  ___  / _(_)__ ___ _________ _/ /_(_)__  ___  ___
/ /__/ _ \/ _ \/ _/ / _ `/ // / __/ _ `/ __/ / _ \/ _ \(_-<
\___/\___/_//_/_//_/\_, /\_,_/_/  \_,_/\__/_/\___/_//_/___/
                   /___/
******************************************************************************/;

Bool Property OptDebug = TRUE Auto Hidden

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

Function Print(String Msg)
{print messages out to the notification area.}

	Debug.Notification("[DM2] " + Msg);
	Return
EndFunction

Function PrintDebug(String Msg)
{send a message to the console.}

	If(!self.OptDebug)
		Return
	EndIf

	MiscUtil.PrintConsole("[DM2] " + Msg)
	Return
EndFunction

Function WheelMenuSet(Int Num, String Text, String Tip, Bool Enabled=True)
{assign things to wheel menu positions.}

	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",Num,Text)
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",Num,Tip)
	UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",Num,Enabled)

	Return
EndFunction

Function EquipStoredArmor(Actor Who, Bool Strip=True)
{equip the items stored for this actor.}

	Form Item
	Int ItemCount = StorageUtil.FormListCount(Who,"DisplayModel.Actor.ArmorList")

	If(Strip)
		;;Who.RemoveAllItems()
		Who.UnequipAll()
	EndIf

	While(ItemCount)
		ItemCount -= 1
		Item = StorageUtil.FormListGet(Who,"DisplayModel.Actor.ArmorList",ItemCount)

		If(Item != None)
			Who.EquipItem(Item)
		EndIf
	EndWhile

	Return
EndFunction

Function StoreEquippedArmor(Actor Who, Actor Dest=None)
{store a list of the items the specified actor is wearing. if a second actor is
specified then the list is stored under that actor instead, copying from the
source.}

	Form Item
	Int ItemCount = Who.GetNumItems()

	If(Dest == None)
		Dest = Who
	EndIf

	StorageUtil.FormListClear(Dest,"DisplayModel.Actor.ArmorList")

	While(ItemCount)
		ItemCount -= 1
		Item = Who.GetNthForm(ItemCount)

		If(Who.IsEquipped(Item))
			If(Item as ObjectReference != None)
				StorageUtil.FormListAdd(Dest,"DisplayModel.Actor.ArmorList",(Item as ObjectReference).GetBaseObject())
			Else
				StorageUtil.FormListAdd(Dest,"DisplayModel.Actor.ArmorList",Item)
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

	Utility.Wait(0.25)

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

Function OnWaitMenu(Bool Opened)
{when we sleep or wait, we want to try and disable any npc running the do
nothing package to prevent them from moving while we wait. it seems package
processing is suspended during wait and there is actually a moment they may get
a step or two away before kicking in again.}

	Int Num = StorageUtil.FormListCount(self.dcc_dm_PackageDoNothing,"DisplayModel.Package.Users")
	Actor Who

	While(Num > 0)
		Num -= 1
		Who = StorageUtil.FormListGet(self.dcc_dm_PackageDoNothing,"DisplayModel.Package.Users",Num) as Actor

		If(Who != None)
			If(Opened)
				who.EnableAI(false)
			Else
				who.EnableAI(true)
			EndIf
		EndIf
	EndWhile

	Return
EndFunction

;/******************************************************************************
******************************************************************************/;

Function AnimationApply(Actor Who, String Which)
{play and store an animation that can be renewed later.}

	self.AnimationSet(Who,Which)
	Debug.SendAnimationEvent(Who,Which)
	Return
EndFunction

String Function AnimationGet(Actor Who)
{return the animation that was stored for this actor.}

	If(StorageUtil.HasStringValue(Who,"DisplayModel.Actor.Animation"))
		Return StorageUtil.GetStringValue(Who,"DisplayModel.Actor.Animation")
	Else
		Return "IdleForceDefaultState"
	Endif
EndFunction

Function AnimationSet(Actor Who, String Which)
{store an animation for an actor.}

	StorageUtil.SetStringValue(Who,"DisplayModel.Actor.Animation",Which)
	Return
EndFunction

Function AnimationRenew(Actor Who)
{replay the stored animation for an actor.}

	Debug.SendAnimationEvent(Who,self.AnimationGet(Who))
	Return
EndFunction

;;;;;;;;
;;;;;;;;

Function SightEventRegister(Actor Who)
;; register for los gains. when we gain sight on an actor that is being told to
;; display we will check to make sure it is still doing the last animation they
;; were told to do.

	self.RegisterForLOS(self.Player,Who)
	Return
EndFunction

Function SightEventUnregister(Actor Who)
;; unregister for los gains.

	self.UnregisterForLOS(self.Player,Who)
	Return
EndFunction

Event OnGainLOS(Actor Who, ObjectReference Target)

	;; if the player sees a display model make sure they are still animating
	;; properly. mostly for things like cell changes.
	If((Target as Actor).GetCurrentPackage() == self.dcc_dm_PackageDoNothing)
		self.AnimationRenew(Target as Actor)
	EndIf

	Return
EndEvent

;/******************************************************************************
   ___      __             _                 ___   ___  ____
  / _ )___ / /  ___ __  __(_)__  __ ______  / _ | / _ \/  _/
 / _  / -_) _ \/ _ `/ |/ / / _ \/ // / __/ / __ |/ ___// /
/____/\__/_//_/\_,_/|___/_/\___/\_,_/_/   /_/ |_/_/  /___/

******************************************************************************/;

Function PersistHackApply(Actor Who)
{apply persistence hacks to keep temporary actors alive.}

	If(StorageUtil.FormListFind(None,"DisplayModel.ActorList.Persist",Who) != -1)
		;; don't re-register if we are already in here.
		Return
	EndIf

	Who.RegisterForUpdate(600)
	StorageUtil.FormListAdd(None,"DisplayModel.ActorList.Persist",Who,FALSE)
	self.PrintDebug(Who.GetDisplayName() + " shall persist.")

	Return
EndFunction

Function PersistHackClear(Actor Who)
{clear the persistence hack. take into account known mods that also use this
same persistence hack (more or less, mine only, for the time being) so that
we don't fuck up those mods.}

	StorageUtil.FormListRemove(None,"DisplayModel.ActorList.Persist",Who,TRUE)

	;; mods need to track their persistence hacking via a global scope form
	;; list containing actor references if they want me to support it:
	;; - to create and add to a list.
	;;   StorageUtil.FormListAdd(None,"YourModKey",Actor,FALSE)
	;; - to remove from a list.
	;;   StorageUtil.FormListRemove(None,"YourModKey",Actor,TRUE)

	;; other mods which implement this hack should have simliar as here
	;; to make sure they don't fuck up other mods. to add support for this
	;; mod you should test the SGO.ActorList.Persist list. other mods
	;; are below.

	String[] FourthPartyList = new String[2]
	FourthPartyList[0] = "Untamed.TrackingList"  ;; Untamed
	FourthPartyList[1] = "SGO.ActorList.Persist" ;; Soulgem Oven 2

	Int CurrentMod = 0
	While(CurrentMod < FourthPartyList.Length)
		If(StorageUtil.FormListFind(None,FourthPartyList[CurrentMod],Who) != -1)
			;; if found in any of the fourth party lists then do not
			;; unregister it.
			self.PrintDebug(Who.GetDisplayName() + " persist kept for " + FourthPartyList[CurrentMod])
			Return
		EndIf

		CurrentMod += 1
	EndWhile

	Who.UnregisterForUpdate()
	self.PrintDebug(Who.GetDisplayName() + " persist cleared.")

	Return
EndFunction

Function BehaviourApply(Actor Who, Package What, Int Priority=-1)
;; apply the specified ai behaviour package to the specified actor. if priority
;; is omitted or -1, then this function will automatically decide what priority
;; to use based on how this mod operates. this mod also applies the update
;; registration hack to prevent unnamed actors from being recycled by the game
;; engine if the package being applied is the display model base nothing
;; package.

	If(Priority == -1)
		;; auto determine what priority.
		If(What == self.dcc_dm_PackageDoNothing)
			Priority = 99
		Else
			Priority = 100
		EndIf
	Else
		;; cure out of bounding.
		Priority = PapyrusUtil.ClampInt(Priority,1,100)
	EndIf

	If(What == self.dcc_dm_PackageDoNothing)
		Who.SetRestrained(TRUE)
		Who.SetDontMove(TRUE)
		self.PersistHackApply(Who)
		self.AnimationApply(Who,"ZazAPC001")
		self.SightEventRegister(Who)
		self.OutfitApply(Who,self.dcc_dm_OutfitNone)
		self.OutfitApply(Who,self.dcc_dm_OutfitNone,TRUE)
	EndIf

	ActorUtil.AddPackageOverride(Who,What,Priority)
	Who.EvaluatePackage()

	StorageUtil.FormListAdd(what,"DisplayModel.Package.Users",Who)

	Return
EndFunction

Function BehaviourClear(Actor Who, Package What)
;; remove the specified package from the overrides of the specified actor. it
;; will also clear the update registration hack if the package being removed
;; is the display model base nothing package.

	ActorUtil.RemovePackageOverride(Who,What)
	Who.EvaluatePackage()

	If(What == self.dcc_dm_PackageDoNothing)
		Who.SetRestrained(FALSE)
		Who.SetDontMove(FALSE)
		self.PersistHackClear(Who)
		self.SightEventUnregister(Who)
		self.OutfitRestore(Who)
	EndIf

	StorageUtil.FormListRemove(what,"DisplayModel.Package.Users",Who,TRUE)
	Return
EndFunction

;/******************************************************************************
  ____       __  ____ __    ___   ___  ____
 / __ \__ __/ /_/ _(_) /_  / _ | / _ \/  _/
/ /_/ / // / __/ _/ / __/ / __ |/ ___// /
\____/\_,_/\__/_//_/\__/ /_/ |_/_/  /___/

******************************************************************************/;

Function OutfitApply(Actor Who, Outfit What, Bool Sleep=false)
{Set an outfit for a specified actor. if it is the first time used on the actor
then it will mark down what the original outfit was so that it can be restored
later.}

	If(StorageUtil.GetFormValue(Who,"DisplayModel.Actor.OutfitNormal") == None)
		StorageUtil.SetFormValue(Who,"DisplayModel.Actor.OutfitNormal",Who.GetActorBase().GetOutfit(FALSE))
		StorageUtil.SetFormValue(Who,"DisplayModel.Actor.OutfitSleep",Who.GetActorBase().GetOutfit(TRUE))
	EndIf

	who.SetOutfit(What,Sleep)
	Return
EndFunction

Function OutfitRestore(Actor Who)
{restore an outfit that was stored for the specified actor, if it had been
saved previously.}

	Who.SetOutfit(StorageUtil.GetFormValue(Who,"DisplayModel.Actor.OutfitNormal") as Outfit, FALSE)
	Who.SetOutfit(StorageUtil.GetFormValue(Who,"DisplayModel.Actor.OutfitSleep") as Outfit, TRUE)

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

	Actor Target = Game.GetCurrentCrosshairRef() as Actor
	Bool TargetEnable
	String TargetLabel
	bool CloneEnable
	string CloneLabel
	Int Result

	If(target != None)
		TargetEnable = TRUE
		TargetLabel = "Target " + Target.GetDisplayName()
	Else
		TargetEnable = FALSE
		TargetLabel = "[No Target]"
	EndIf

	If(self.CloneActorGet(self.Player) != None)
		CloneEnable = TRUE
		CloneLabel = "Spawn " + self.CloneActorGet(self.Player).GetDisplayName()
	Else
		CloneEnable = FALSE
		CloneLabel = "[No Source Selected]"
	EndIf

	UIExtensions.InitMenu("UIWheelMenu")
	self.WheelMenuSet(0,TargetLabel,"Mark the target for cloning.",TargetEnable)
	self.WheelMenuSet(1,"Target Self","Mark yourself for cloning.",TRUE)
	self.WheelMenuSet(4,"Set Location","Mark your spot and angle for spawning the next clone.",TRUE)
	self.WheelMenuSet(7,CloneLabel,"Spawn a clone at the specified location.",CloneEnable)
	Result = UIExtensions.OpenMenu("UIWheelMenu")

	If(Result == 0)
		self.CloneActorCopy(self.Player,Target)
	ElseIf(Result == 1)
		self.CloneActorCopy(self.Player,self.Player)
	ElseIf(Result == 4)
		self.CloneMarkerPlace(self.Player)
	ElseIf(Result == 7)
		self.CloneActorPaste(self.Player)
	EndIf

	Return
EndFunction

Function CloneMarkerClear(Actor Who)
{Clear the location saved for clone spawning.}

	ObjectReference Here = self.CloneMarkerGet(Who)

	If(Here != None)
		Here.Delete()
	EndIf

	StorageUtil.UnsetFormValue(Who,"DisplayModel.Clone.Marker")

	If(Who == self.Player)
		self.Print("Your clone location has been cleared.")
	EndIf

	Return
EndFunction

ObjectReference Function CloneMarkerGet(Actor Who)
{Fetch a location we previously jotted down.}

	Return StorageUtil.GetFormValue(Who,"DisplayModel.Clone.Marker") as ObjectReference
EndFunction

ObjectReference Function CloneMarkerPlace(Actor Who)
{place a marker in the world where clones will be pasted to. this is derived
from the casters location and angle. stand where you want the actor to be and
the direction you want them to face prior to using this. each actor can place
their own paste marker. for i don't know, if some reason skyrim becomes
multiplayer tomorrow or someshit. this marker will also be returned as well as
stored in storage util.}

	ObjectReference Here

	Here = self.CloneMarkerGet(Who)
	If(Here != None)
		Here.Delete()
	EndIf

	Here = Who.PlaceAtMe(self.StaticX,1,TRUE,FALSE)
	self.CloneMarkerSet(Who,Here)

	Return Here
EndFunction

Function CloneMarkerSet(Actor Who, ObjectReference What)
{Jot down a location where we want clones to spawn. You can use this to define
a location which was not created by CloneMarkerPlace.}

	StorageUtil.SetFormValue(Who,"DisplayModel.Clone.Marker",What)

	If(Who == self.Player)
		self.Print("Your clone location has been set.")
	EndIf

	Return
EndFunction

;;;;;;;;
;;;;;;;;

Function CloneActorClear(Actor Who)
{Clear the saved actor.}

	StorageUtil.UnsetFormValue(Who,"DisplayModel.Clone.Actor")

	If(Who == self.Player)
		self.Print("Your clone tool has been cleared.")
	EndIf

	Return
EndFunction

Function CloneActorCopy(Actor Who, Actor Source)
{Save an actor we want to copy.}

	StorageUtil.SetFormValue(Who,"DisplayModel.Clone.Actor",Source)

	If(Who == self.Player)
		self.Print(Source.GetDisplayName() + " has been marked for cloning.")
	EndIf

	Return
EndFunction

Actor Function CloneActorGet(Actor Who)
{Fetch the actor we wanted to clone.}

	Return StorageUtil.GetFormValue(Who,"DisplayModel.Clone.Actor") as Actor
EndFunction

Actor Function CloneActorPaste(Actor Who)
{Place a new actor in the world that is a copy of our source.}

	Actor Source = self.CloneActorGet(Who)
	ObjectReference Here = self.CloneMarkerGet(Who)

	;; make sure we had an actor.
	If(Source == None)
		If(Who == self.Player)
			self.Print("You have not selected any actors for cloning.")
		EndIf
		Return None
	EndIf

	;; make sure we had a drop point. if not, drop one.
	If(Here == None)
		Here = self.CloneMarkerPlace(Who)
	EndIf

	;;;;;;;;
	;;;;;;;;

	;; place a new object at our location.
	Actor Clone = Here.PlaceAtMe(Source.GetActorBase(),1,TRUE,FALSE) as Actor
	If(clone == None)
		self.Print("Creating a clone fucked up for some reason.")
		Return None
	EndIf

	;; stand there like a tool doing nothing with nothing.
	self.BehaviourApply(Clone,self.dcc_dm_PackageDoNothing)
	Clone.RemoveAllItems()

	;; and copy the source armor.
	self.StoreEquippedArmor(Who,Clone)
	self.EquipStoredArmor(Clone)

	Return Clone
EndFunction

