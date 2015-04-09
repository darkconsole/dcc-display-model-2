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

Package Property dcc_dm_PackageDoNothing Auto

;/******************************************************************************
  _____          ____                    __  _
 / ___/__  ___  / _(_)__ ___ _________ _/ /_(_)__  ___  ___
/ /__/ _ \/ _ \/ _/ / _ `/ // / __/ _ `/ __/ / _ \/ _ \(_-<
\___/\___/_//_/_//_/\_, /\_,_/_/  \_,_/\__/_/\___/_//_/___/
                   /___/
******************************************************************************/;

Bool Property OptDebug = False Auto

;/******************************************************************************
  __  ____  _ ___ __         __  ___    __  __           __
 / / / / /_(_) (_) /___ __  /  |/  /__ / /_/ /  ___  ___/ /__
/ /_/ / __/ / / / __/ // / / /|_/ / -_) __/ _ \/ _ \/ _  (_-<
\____/\__/_/_/_/\__/\_, / /_/  /_/\__/\__/_//_/\___/\_,_/___/
                   /___/
******************************************************************************/;

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

;/******************************************************************************
   ___      __             _                 ___   ___  ____
  / _ )___ / /  ___ __  __(_)__  __ ______  / _ | / _ \/  _/
 / _  / -_) _ \/ _ `/ |/ / / _ \/ // / __/ / __ |/ ___// /
/____/\__/_//_/\_,_/|___/_/\___/\_,_/_/   /_/ |_/_/  /___/

******************************************************************************/;

Function BehaviourApply(Actor who, Package what, Int priority=-1)
;; apply the specified ai behaviour package to the specified actor. if priority
;; is omitted or -1, then this function will automatically decide what priority
;; to use based on how this mod operates.

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

	ActorUtil.AddPackageOverride(who,what,priority)
	Return
EndFunction

Function BehaviourClear(Actor who, Package what)
;; remove the specified package from the overrides of the specified actor.

	ActorUtil.RemovePackageOverride(who,what)
	Return
EndFunction

;/******************************************************************************
  _______                    ___   ___  ____
 / ___/ /__  ___  ___ ____  / _ | / _ \/  _/
/ /__/ / _ \/ _ \/ -_) __/ / __ |/ ___// /
\___/_/\___/_//_/\__/_/   /_/ |_/_/  /___/

******************************************************************************/;

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
multiplayer tomorrow or someshit.}

	ObjectReference loc = who.PlaceAtMe(self.StaticX,1,True,False)

	self.CloneMarkerSet(who,loc)
	Return loc
EndFunction

Function CloneMarkerSet(Actor who, ObjectReference what)
{Jot down a location where we want clones to spawn.}

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

ObjectReference Function CloneActorPaste(Actor who)
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
	ObjectReference clone = loc.PlaceAtMe(source,1,True,False)
	If(clone == None)
		self.Print("Creating a clone fucked up for some reason.")
		Return None
	EndIf

	;; stand there like a tool doing nothing.
	self.BehaviourApply(who,self.dcc_dm_PackageDoNothing)

	Return clone
EndFunction

