Scriptname dcc_dm_QuestController extends Quest

Int Function Version() Global
{current version number}

	Return 203
EndFunction

dcc_dm_QuestController Function Get() Global
{get the main controller api}

	Return Game.GetFormFromFile(0xD64,"dcc-dm2.esp") as dcc_dm_QuestController
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game Forms ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor Property Player Auto
Static Property StaticX Auto ;; NA NA NA NA WIS-CONSIN DETH TRIP
SexLabFramework Property SexLab Auto Hidden;
slaFrameworkScr Property Aroused Auto Hidden

dcc_dm_QuestArousal Property ArousalSystem Auto

Package Property dcc_dm_PackageDoNothing Auto
Package Property dcc_dm_PackageDoNothingMovable Auto
Package Property dcc_dm_PackageFollow Auto

FormList Property dcc_dm_ListPoseCage Auto
FormList Property dcc_dm_ListPoseChain Auto
FormList Property dcc_dm_ListPoseCross Auto
FormList Property dcc_dm_ListPoseCrux Auto
FormList Property dcc_dm_ListPoseMisc Auto
FormList Property dcc_dm_ListPosePillory Auto
FormList Property dcc_dm_ListPosePost Auto
FormList Property dcc_dm_ListPoseRestrainedTo Auto
FormList Property dcc_dm_ListPoseRopeBondage Auto
FormList Property dcc_dm_ListPoseSpitRoast Auto
FormList Property dcc_dm_ListPoseSubmit Auto
FormList Property dcc_dm_ListDollStand Auto

ImageSpaceModifier Property dcc_dm_ImodControlMode Auto
ImageSpaceModifier Property dcc_dm_ImodControlModeLongPress Auto
ImageSpaceModifier Property dcc_dm_ImodMenu Auto
Outfit Property dcc_dm_OutfitNone Auto

Faction Property dcc_dm_FactionControl Auto
Faction Property dcc_dm_FactionOutfit Auto
Faction Property dcc_dm_FactionUsingObject Auto
Faction Property dcc_dm_FactionAroused Auto

FormList Property dcc_dm_ListTransformPose_0275 Auto
Message Property dcc_dm_MsgUseObject Auto
Spell Property dcc_dm_SpellArousedFxOnDelay Auto
Spell Property dcc_dm_SpellArousedFxNow Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Config Options ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Property OK = FALSE Auto Hidden
{defines if we think our dependencies are all good.}

Bool Property OptDebug = TRUE Auto Hidden
{if we should print verbose debugging to the console.}

Float Property OptLongPressTime = 0.3 Auto Hidden
{how long to hold teh key to trigger a long press.}

Bool Property OptResumePoseAfterMove = TRUE Auto Hidden
{resume the pose after moving}

Bool Property OptTutorials = TRUE Auto Hidden
{show helpful dialogs when applicable.}

Bool Property OptValidateActor = TRUE Auto Hidden
{allows sexlab to reject an actor for wahtever reason}

Bool Property OptUseZazSlavery = FALSE Auto Hidden
{make use of and respect the zaz slavery system.}

Bool Property OptPoseCancelNIOHH = TRUE Auto Hidden
{if we should cancel NIOHH out while posed so they align.}

Float Property OptArousedTickFactor = 2.0 Auto Hidden
{a multiplier for modding arousal level.}

Bool Property OptArousedTickExposure = TRUE Auto Hidden
{if we should modify the exposure on arousal changes.}

Bool Property OptArousedTickTimeRate = TRUE Auto Hidden
{if we should modify the time rate on arousal changes.}

Bool Property OptArousedTickSound = TRUE Auto Hidden
{if we should play a sound when arousal ticks. a moan.}

Bool Property OptArousedTickExpression = TRUE Auto Hidden
{if we should do a face expression when arousal ticks.}

Bool Property OptArousedTickBlush = TRUE Auto Hidden
{if we should do a face blush when arousal ticks.}

Bool Property OptArousedNPC = TRUE Auto Hidden
{if we should work against npcs as well}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Strings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; these are not about being shorter to type. they are about being impossible
;; to typo. compiler will shit fits. also maintain if i have to change them.

String Property KeyListPersist    = "DM2.List.Persist" Auto Hidden        ;; storageutil global
String Property KeyListArousal    = "DM2.List.Arousal" Auto Hidden        ;; storageutil global
String Property KeyActorRestrain  = "DM2.Actor.Restrain" Auto Hidden      ;; storageutil actor
String Property KeyActorPkg       = "DM2.Actor.Package" Auto Hidden       ;; storageutil actor
String Property KeyActorPkgPrev   = "DM2.Actor.PackagePrev" Auto Hidden   ;; storageutil actor
String Property KeyActorMarker    = "DM2.Actor.Marker" Auto Hidden        ;; storageutil actor
String Property KeyActorOutfit1   = "DM2.Actor.Outfit1" Auto Hidden       ;; storageutil actor
String Property KeyActorOutfit2   = "DM2.Actor.Outfit2" Auto Hidden       ;; storageutil actor
String Property KeyActorTransform = "DM2.Actor.Transform" Auto Hidden     ;; storageutil actor
String Property KeyActorUsing     = "DM2.Actor.Using" Auto Hidden         ;; storageutil actor
String Property KeyCtrlMode       = "DM2.Control.Mode" Auto Hidden        ;; storageutil global
String Property KeyCtrlActor      = "DM2.Control.Actor" Auto Hidden       ;; storageutil global
String Property KeyCtrlPkgList    = "DM2.Control.PackageList" Auto Hidden ;; storageutil global
String Property KeyCtrlPkgIter    = "DM2.Control.PackageIter" Auto Hidden ;; storageutil global
String Property KeyModeNone       = "None" Auto Hidden
String Property KeyModePose       = "Pose" Auto Hidden
String Property KeyModeMove       = "Move" Auto Hidden
String Property KeyModeOvershadow = "Overshadow" Auto Hidden
String Property KeyModeMoveObject = "MoveObject" Auto Hidden

Bool Function IsInstalledNiOverride(Bool Popup=TRUE)
{make sure NiOverride is installed and active.}

	If(SKSE.GetPluginVersion("NiOverride") == -1)
		If(Popup)
			Debug.MessageBox("NiOverride not installed. Install it by installing RaceMenu or by installing it standalone from the Nexus.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledUIExtensions(Bool Popup=TRUE)
{make sure UIExtensions is installed and active.}

	If(Game.GetModByName("UIExtensions.esp") == 255)
		If(Popup)
			Debug.MessageBox("UIExtensions not installed. Install it from the Nexus.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledZap(Bool Popup=TRUE)
{make sure UIExtensions is installed and active.}

	If(Game.GetModByName("ZaZAnimationPack.esm") == 255)
		If(Popup)
			Debug.MessageBox("ZaZ Animation Pack not installed. Install it from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledSexLab(Bool Popup=TRUE)
{make sure SexLab is installed.}

	If(Game.GetModByName("SexLab.esm") == 255)
		If(Popup)
			Debug.MessageBox("SexLab not installed. Install it from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	self.SexLab = Game.GetFormFromFile(0xD62,"SexLab.esm") as SexLabFramework
	Return TRUE
EndFunction

Bool Function IsInstalledSexLabReally(Bool Popup=TRUE)
{make sure sexlab is active.}

	If(self.SexLab == None)
		Return FALSE
	EndIf

	If(!self.SexLab.Enabled && Popup)
		Debug.MessageBox("It appears SexLab is not currently active. Be sure to visit its MCM and hit Install.")
	EndIf

	Return self.SexLab.Enabled
EndFunction

Bool Function IsInstalledPapyrusUtil(Bool Popup=TRUE)
{make sure papyrus util is a version we need. if we test this after sexlab we
can basically promise it will be there. we need to make sure that shlongs of
skyrim though didn't fuck it up again with an older version, that will break
the use of AdjustFloatValue and the like.}

	If(PapyrusUtil.GetVersion() < 31)
		If(Popup)
			Debug.MessageBox("Your PapyrusUtil is too old or has been overwritten by something like SOS. Install PapyrusUtil 3.1 from LoversLab and make sure it dominates the load order.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledAroused(Bool Popup=FALSE)
{check if we have sexlab aroused support.}

	If(Game.GetModByName("SexLabAroused.esm") == 255)
		If(Popup)
			Debug.MessageBox("SexLab Aroused is not installed. Support will be disabled.")
		EndIf

		self.Aroused = None
		Return FALSE
	EndIf

	self.Aroused = Game.GetFormFromFile(0x04290F,"SexLabAroused.esm") as slaFrameworkScr
	If(self.Aroused == None)
		Debug.MessageBox("SexLab Aroused may have changed something. Support will be disabled.")
		Return FALSE
	EndIf

	Return TRUE
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ResetMod()
{perform a quest (and ergo mod) reboot. quest RunOnce is disabled so that we
trigger OnInit() to finish the deal.}

	self.Reset()
	Utility.Wait(0.25)
	self.Stop()
	Utility.Wait(0.25)
	self.Start()

	Return
EndFunction

Function ResetMod_Prepare()
{check that everything this mod needs to run exists and is ready.}

	;; hard dependencies.

	If(!self.IsInstalledUIExtensions())
		Return
	EndIf

	If(!self.IsInstalledZap())
		Return
	EndIf

	If(!self.IsInstalledSexLab())
		Return
	EndIf

	If(!self.IsInstalledPapyrusUtil())
		Return
	EndIf

	;; soft dependencies.

	self.IsInstalledAroused()

	self.OK = TRUE
	Return
EndFunction

Function ResetMod_Values()
{force reset settings to default values.}

	self.OptDebug = TRUE
	self.OptLongPressTime = 0.3

	Return
EndFunction

Function ResetMod_Spells()
{force refresh of the spells.}

	Return
EndFunction

Function ResetMod_Events()
{cleanup and reinit of any event handling things.}

	self.UnregisterForMenu("Sleep/Wait Menu")
	self.RegisterForMenu("Sleep/Wait Menu")

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mod Utility Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function FormListLock(Form Scope, String Name, String CalledBy="Unknown")
{create a spinlock for a formlist.}

	Int Count = 0

	While(StorageUtil.GetStringValue(Scope,(Name+"--FormListLock")) != "")
		Count += 1
		self.PrintDebug(CalledBy + "(" + Count + ") spinning from " + StorageUtil.GetStringValue(Scope,(Name+"--FormListLock")))
		Utility.Wait(0.25)
	EndWhile

	StorageUtil.SetStringValue(Scope,(Name+"--FormListLock"),CalledBy)
EndFunction

Function FormListUnlock(Form Scope, String Name)
{release a spinlock for a formlist.}

	StorageUtil.UnsetStringValue(Scope,(Name+"--FormListLock"))
EndFunction

Function FormListFlushLost(Form Scope, String Name)
{forcibly remove anything from the specified form list if it retrieves from
storage as None.}

	self.FormListLock(Scope,Name,"FormListFlushLost")

	Int Count = 0
	Int Len = StorageUtil.FormListCount(Scope,Name)
	Int Iter = 0
	Form What 

	While(Iter < Len)
		What = StorageUtil.FormListGet(Scope,Name,Iter)

		If(What == None)
			StorageUtil.FormListRemoveAt(Scope,Name,Iter)
			Len -= 1
			Count += 1
		Else
			Iter += 1
		EndIf
	EndWhile

	If(Count > 0)
		self.PrintDebug("flushed " + Count + " killed/lost/trashed refs from " + Name)
	EndIf

	self.FormListUnlock(Scope,Name)

	Return
EndFunction

String Function FormListLabel(String Prefix, FormList What)
{generate a label for the list menu with the name and number of things in the
list that is provided.}

	Return Prefix + ": " + What.GetSize() + " Poses"
EndFunction

Function Print(String Msg)
{send a message to the notification area.}

	Debug.Notification("[DM2] " + Msg)
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

Function PrintLog(String Msg)
{print to log file}

	Debug.Trace("[DM2] " + Msg);
	Return
EndFunction

Function UnequipShout(Actor Who)
{wrapper around how much of a pain in the ass it is to unequip the voice
slot spell.}

	If(Who.GetEquippedSpell(2) != None)
		Who.UnequipSpell(Who.GetEquippedSpell(2),2)
	EndIf

	If(Who.GetEquippedShout() != None)
		Who.UnequipShout(Who.GetEquippedShout())
	EndIf

	Return
EndFunction

Function ControlKeyDownSet(String Ctrl, Bool IsDown)
{marks when a control is still being held.}
	
	;; all this crap is being done because from what i can tell the
	;; functions in Input.psc do not work for gamepad at all. and don't
	;; start with me i wasted a lot of time on that.

	;; rolling with Set's in both cases because i imagine updating a value
	;; will actually be faster than creating it and deleting it from wahtever
	;; internal structures storage util has going on.

	If(IsDown)
		StorageUtil.SetIntValue(None,("DM.Input." + Ctrl),1)
	Else
		StorageUtil.SetIntValue(None,("DM.Input." + Ctrl),0)
	EndIf

	Return
EndFunction

Bool Function ControlKeyDownGet(String Ctrl)
{check if a control is still down.}

	If(Storageutil.GetIntValue(None,("DM.Input." + Ctrl),Missing=0) == 1)
		Return TRUE
	Else
		Return FALSE
	EndIf
EndFunction

Function AlignObject(ObjectReference What, ObjectReference With)
{align two objects but making sure its standing straight up and didn't get lold
by the terrain angle or something.}

	What.SetPosition(With.GetPositionX(),With.GetPositionY(),With.GetPositionZ())
	What.SetAngle(0,With.GetAngleY(),With.GetAngleZ())

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Control Mode API ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Function ControlPackageIterGet()
{get the iterator used for package list traversing.}

	Return StorageUtil.GetIntValue(None,self.KeyCtrlPkgIter,Missing=0)
EndFunction

Function ControlPackageIterSet(Int Value)
{store the iterator used for package list traversing.}

	StorageUtil.SetIntValue(None,self.KeyCtrlPkgIter,Value)	
	Return
EndFunction

FormList Function ControlPackageListGet()
{get the package list used for cycling poses.}

	Return StorageUtil.GetFormValue(None,self.KeyCtrlPkgList) as FormList
EndFunction

Function ControlPackageListSet(FormList PkgList)
{set the package list used for cycling poses.}

	StorageUtil.SetFormValue(None,self.KeyCtrlPkgList,PkgList)
	Return
EndFunction

Actor Function ControlActorGet()
{get the target actor of control.}
	
	Return StorageUtil.GetFormValue(None,self.KeyCtrlActor) as Actor
EndFunction

Function ControlActorSet(Actor Who)
{set the target actor of control.}

	StorageUtil.SetFormValue(None,self.KeyCtrlActor,Who)
	Return
EndFunction

ObjectReference Function ControlObjectGet()
{get the target object of control.}

	Return StorageUtil.GetFormValue(None,self.KeyCtrlActor) as ObjectReference
EndFunction

Function ControlObjectSet(ObjectReference What)
{set the target object of control.}

	StorageUtil.SetFormValue(None,self.KeyCtrlActor,What)
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

String Function ControlModeGet()
{fetch what control mode we are in.}

	Return StorageUtil.GetStringValue(None, self.KeyCtrlMode, Missing=self.KeyModeNone)
EndFunction

Function ControlModeSet(String Mode)
{set what control mode we are in}

	String OldMode = self.ControlModeGet()

	;; doing nothing if we didn't actually change modes.
	If(OldMode == Mode)
		Return
	EndIf

	;; disable the previous mode.
	If(OldMode == self.KeyModePose)
		self.ControlModeClear_ModePose()
	ElseIf(OldMode == self.KeyModeOvershadow)
		self.ControlModeClear_ModeOvershadow()
	ElseIf(OldMode == self.KeyModeMove)
		self.ControlModeClear_ModeMove()
	ElseIf(OldMode == self.KeyModeMoveObject)
		self.ControlModeClear_ModeMoveObject()
	EndIf
	self.dcc_dm_ImodControlMode.Remove()

	If(Mode == self.KeyModeNone)
		StorageUtil.SetStringValue(None,self.KeyCtrlMode,Mode)
		Return
	EndIf

	;; enable the new mode.
	If(Mode == self.KeyModePose)
		self.ControlModeSet_ModePose()
	ElseIf(Mode == self.KeyModeOvershadow)
		self.ControlModeSet_ModeOvershadow()
	ElseIf(Mode == self.KeyModeMove)
		self.ControlModeSet_ModeMove()
	ElseIf(Mode == self.KeyModeMoveObject)
		self.ControlModeSet_ModeMoveObject()
	EndIf

	StorageUtil.SetStringValue(None,self.KeyCtrlMode,Mode)
	self.dcc_dm_ImodControlMode.Apply(1.0)
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function ControlModeSet_ModePose()
{register pose mode controls.}

	self.UnequipShout(self.Player)

	self.RegisterForControl("Sprint")
	self.RegisterForControl("Shout")

	If(self.OptTutorials)
		String Msg = ""
		Msg += "POSE MODE ----\n"
		Msg += "Short Press SHOUT for next pose.\n"
		Msg += "Short Press SPRINT for previous pose.\n"
		Msg += "Long Press SHOUT to leave pose mode.\n"
		Msg += "Long Press SPRINT to change pose lists.\n"
		Debug.MessageBox(Msg)
	EndIf
	Return
EndFunction

Function ControlModeClear_ModePose()
{clear pose mode controls.}

	self.UnregisterForControl("Sprint")
	self.UnregisterForControl("Shout")
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function ControlModeSet_ModeOvershadow()
{register overshadow mode controls.}

	Actor Who = self.ControlActorGet()

	self.UnequipShout(self.Player)
	self.UnequipShout(Who)

	self.BehaviourClear(Who,TRUE)
	self.Player.SetPlayerControls(FALSE)
	Who.SetPlayerControls(TRUE)
	Game.SetCameraTarget(Who)
	Who.EnableAI()

	Game.SetPlayerAiDriven(TRUE)
	;;self.Player.SetDontMove(TRUE)
	;;self.Player.SetRestrained(TRUE)
	Game.ForceFirstPerson()

	self.RegisterForControl("Shout")
	Return
EndFunction

Function ControlModeClear_ModeOvershadow()
{clear overshadow mode controls.}

	Actor Who = self.ControlActorGet()

	self.Player.SetPlayerControls(TRUE)
	Who.SetPlayerControls(FALSE)
	Game.SetCameraTarget(self.Player)
	self.BehaviourDefault(Who)

	Game.SetPlayerAiDriven(FALSE)
	;;self.Player.SetDontMove(FALSE)
	;;self.Player.SetRestrained(FALSE)

	self.ControlActorSet(None)
	self.UnregisterForControl("Shout")
	Debug.SendAnimationEvent(self.Player,"IdleForceDefaultState")
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function ControlModeSet_ModeMove()
{register move mode controls}

	self.UnequipShout(self.Player)
	self.RegisterForControl("Shout")

	If(self.OptTutorials)
	String Msg = ""
		Msg += "MOVE MODE ----\n"
		Msg += "Short Press SHOUT to command  them to move to your exact position and angle.\n"
		Msg += "Long Press SHOUT to leave move mode.\n"
		Debug.MessageBox(Msg)
	EndIf
	Return
EndFunction

Function ControlModeClear_ModeMove()
{clear move mode controls}

	self.UnregisterForControl("Shout")
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function ControlModeSet_ModeMoveObject()
{register move mode controls}

	self.UnequipShout(self.Player)
	self.RegisterForControl("Shout")

	If(self.OptTutorials)
	String Msg = ""
		Msg += "MOVE MODE ----\n"
		Msg += "Short Press SHOUT to move it to your exact position and angle.\n"
		Msg += "Long Press SHOUT to leave move mode.\n"
		Debug.MessageBox(Msg)
	EndIf
EndFunction

Function ControlModeClear_ModeMoveObject()
{clear move mode object controls}

	self.UnregisterForControl("Shout")
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function ControlModeOvershadowStart(Actor Who)
{begin overshadow mode. currently unused because controlling another actor
i have yet to figure out how to perfect. it has some severely annoying
glitches often.}

	If(!self.ActorSexuallyValid(Who))
		Return
	EndIf

	self.ControlActorSet(Who)
	self.ControlModeSet(self.KeyModeOvershadow)
	Return
EndFunction

Function ControlModeMoveStart(Actor Who)
{begin move command mode.}

	If(!self.ActorSexuallyValid(Who))
		Return
	EndIf

	self.PrintDebug("Move Mode Start")

	self.ControlActorSet(Who)
	self.ControlModeSet(self.KeyModeMove)
	Return
EndFunction

Function ControlModeMoveCommand()
{tell actor to move to location.}

	Actor Who = self.ControlActorGet()

	If(!Who)
		Return
	EndIf

	self.PrintDebug("Move command issued to " + Who.GetDisplayName())

	Package Pkg = self.BehaviourPackageGet(Who)
	Bool Restrain = self.BehaviourRestrainGet(Who)
	ObjectReference Device = self.ActorUsingGet(Who)
	ObjectReference Where = self.ActorMarkerPlaceAt(Who,self.Player)

	;; keep the actor from sandboxing, but let them move.
	self.ActorArousalUnregister(Who)
	self.BehaviourApply(Who,self.dcc_dm_PackageDoNothingMovable,FALSE)
	self.AnimationReset(Who)
	self.AnimationPointDown(self.Player)

	;; then go there. this function should lock until they arrive.
	self.PrintDebug("Pathing Command Issued to " + Who.GetDisplayName())
	self.BehaviourRestrainSet(Who,FALSE)
	self.PrintDebug("Pathing: " + Who.PathToReference(Where,1.0))

	;; then clamp them down again and make sure they are exactly how we wanted
	;; them to be.
	self.BehaviourClear(Who,FALSE)
	self.AlignObject(Who,Where)

	;; if they were using something the device should be relocated.
	If(Device)
		self.AlignObject(Device,Where)
	EndIf

	;; resume their previous pose after the move.
	If(self.OptResumePoseAfterMove && Pkg != None)
		self.BehaviourApply(Who,Pkg,Restrain)
		self.ActorArousalRegister(Who)
	EndIf

	self.PrintDebug("Move Command Done " + Who.GetDisplayName())
	Return
EndFunction

Function ControlModeMoveObjectStart(ObjectReference What)
{begin moving object command mode.}

	If(What == None)
		Return
	EndIf

	self.PrintDebug("Move Object Mode Start")

	self.ControlObjectSet(What)
	self.ControlModeSet(self.KeyModeMoveObject)
	Return
EndFunction

Function ControlModeMoveObjectCommand()
{tell object to move to location.}

	ObjectReference Object = self.ControlObjectGet()

	If(Object == None)
		self.ControlModeSet(self.KeyModeNone)
	EndIf

	self.AlignObject(Object,self.Player)
	Return
EndFunction

Function ControlModePoseStart(Actor Who, String ModeName, FormList PoseList)
{begin pose command mode.}

	If(!self.ActorSexuallyValid(Who))
		Return
	EndIf

	self.PrintDebug(ModeName + " Pose Mode Enabled")

	self.ControlPackageIterSet(-1)
	self.ControlPackageListSet(PoseList)
	self.ControlActorSet(Who)
	self.ControlModeSet(self.KeyModePose)
	self.ActorArousalRegister(Who)

	self.ControlModePoseNext()
	Return
EndFunction

Function ControlModePoseNext(Int Inc=1)
{cycle poses from list.}

	FormList Items = self.ControlPackageListGet()
	Actor Who = self.ControlActorGet()
	Int Current = PapyrusUtil.WrapInt((self.ControlPackageIterGet() + Inc),(Items.GetSize() - 1))

	If(Who == None)
		Return
	EndIf

	self.PrintDebug("Applying pose " + (Current + 1) + " of " + Items.GetSize())
	self.BehaviourApply(Who,(Items.GetAt(Current) as Package),self.BehaviourRestrainGet(Who))

	;;;;;;;;

	self.ControlPackageIterSet(Current)
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NiOverride ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Float[] Function PoseTransformFind(Package Pkg)
{find the transform for this package if exists. if it doesn't it still returns the
transform array just with all zeros.}

	Float[] Val = new Float[3]
	Val[0] = 0.0
	Val[1] = 0.0
	Val[2] = 0.0

	If(self.dcc_dm_ListTransformPose_0275.Find(Pkg) >= 0)
		Val[2] = Val[2] + 2.75
	EndIf

	Return Val
EndFunction

Function PoseTransformClear(Actor Who)
{clear an NIO transform}

	Int IsFemale = Who.GetLeveledActorBase().GetSex()

	NiOverride.RemoveNodeTransformPosition(Who,FALSE,IsFemale,"NPC","DM2.PoseTransform")
	NiOverride.RemoveNodeTransformPosition(Who,FALSE,IsFemale,"NPC","DM2.PoseCancelNIOHH")
	NiOverride.RemoveNodeTransformScale(Who,FALSE,IsFemale,"NPC","DM2.PoseCancelNIOHH")
	NiOverride.UpdateNodeTransform(Who,FALSE,IsFemale,"NPC")
	Return
EndFunction

Function PoseTransformApply(Actor Who, Float[] Value)
{apply an NIO transform}

	Int IsFemale = Who.GetLeveledActorBase().GetSex()

	;; add the offset for this animation.
	NiOverride.AddNodeTransformPosition(Who,FALSE,IsFemale,"NPC","DM2.PoseTransform", Value)

	;; cancel out nio hh. based on how ash baby is doing it in sexlab, seemed pretty smrt.
	If(self.OptPoseCancelNIOHH && NiOverride.HasNodeTransformPosition(Who,FALSE,IsFemale,"NPC","internal"))
		Float HS = NiOverride.GetNodeTransformScale(Who,FALSE,IsFemale,"NPC","internal")
		Float[] HH = NiOverride.GetNodeTransformPosition(Who,FALSE,IsFemale,"NPC","internal")
		self.PrintDebug("NIO HH Canceled (" + HH[2] + ", " + HS + ")")

		HS = 1 / HS
		HH[0] = -HH[0]
		HH[1] = -HH[1]
		HH[2] = -HH[2]

		NiOverride.AddNodeTransformPosition(Who,FALSE,IsFemale,"NPC","DM2.PoseCancelNIOHH",HH)
		NiOverride.AddNodeTransformScale(Who,FALSE,IsFemale,"NPC","DM2.PoseCancelNIOHH",HS)
	Else
		self.PrintDebug("No NIO HH Found")
	EndIf

	NiOverride.UpdateNodeTransform(Who,FALSE,IsFemale,"NPC")
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Mod Events ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
{handler for installing and resetting}

	self.OK = FALSE
	self.ResetMod_Prepare()
	self.ResetMod_Values()
	self.ResetMod_Spells()
	self.ResetMod_Events()

	self.Print("Mod Installed.")
	If(self.OK)
		self.Print("Mod Active.")
	Else
		self.Print("Mod Inactive - Go fix missing dependencies.")
	EndIf
	
	Return
EndEvent

Function OnWaitMenu(Bool Opened)
{when we sleep or wait, we want to try and disable any npc running the do
nothing package to prevent them from moving while we wait. it seems package
processing is suspended during wait and there is actually a moment they may get
a step or two away before kicking in again.}

	self.FormListFlushLost(None,self.KeyListPersist)
	Form[] ActorList = StorageUtil.FormListToArray(None,self.KeyListPersist)
	Actor Who
	Int Iter

	While(Iter > ActorList.Length)
		Who = ActorList[Iter] as Actor

		If(Who != None && Who.Is3dLoaded())
			If(Opened)
				who.EnableAI(FALSE)
			Else
				who.EnableAI(TRUE)
			EndIf
		EndIf
	EndWhile

	Return
EndFunction

Event OnControlDown(String Ctrl)
{handle input controls being pressed.}

	String Mode = self.ControlModeGet()
	self.ControlKeyDownSet(Ctrl,TRUE)

	If(Mode == self.KeyModePose)
		self.OnControlDown_ModePose(Ctrl)
	ElseIf(Mode == self.KeyModeOvershadow)
		self.OnControlDown_ModeOvershadow(Ctrl)
	ElseIf(Mode == self.KeyModeMove)
		self.OnControlDown_ModeMove(Ctrl)
	EndIf

	;; Input.IsKeyPressed(Input.GetMappedKey(Ctrl,InputType))
	;; does not seem to work. at least not with gamepads, even though the
	;; damn input mode is just for that. whatever. i invent my own shit.

	If(Mode != self.KeyModeNone)		
		Utility.Wait(self.OptLongPressTime)
		If(self.ControlKeyDownGet(Ctrl))
			self.dcc_dm_ImodControlModeLongPress.Apply(1.0)
		EndIf
	EndIf

	Return
EndEvent

Event OnControlUp(String Ctrl, Float Time)
{handle input controls being released.}

	String Mode = self.ControlModeGet()
	self.ControlKeyDownSet(Ctrl,FALSE)

	If(Mode == self.KeyModePose)
		self.OnControlUp_ModePose(Ctrl,Time)
	ElseIf(Mode == self.KeyModeOvershadow)
		self.OnControlUp_ModeOvershadow(Ctrl,Time)
	ElseIf(Mode == self.KeyModeMove)
		self.OnControlUp_ModeMove(Ctrl,Time)
	ElseIf(Mode == self.KeyModeMoveObject)
		self.OnControlUp_ModeMoveObject(Ctrl,Time)
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function OnControlDown_ModePose(String Ctrl)

	Return
EndFunction

Function OnControlUp_ModePose(String Ctrl, Float Time)

	If(Ctrl == "Sprint")
		If(Time >= self.OptLongPressTime)
			;; long press on sprint opens the pose list menu.
			self.MenuPoseListSelector(self.ControlActorGet())
		Else
			;; short cycles to previous pose
			self.ControlModePoseNext(-1)
		EndIf
	ElseIf(Ctrl == "Shout")
		If(Time >= self.OptLongPressTime)
			;; long press on shout cancels mode.
			self.ControlModeSet(self.KeyModeNone)
		Else
			;; short press on shout cycles next pose.
			self.ControlModePoseNext(1)
		EndIf
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function OnControlDown_ModeOvershadow(String Ctrl)

	Return
EndFunction

Function OnControlUp_ModeOvershadow(String Ctrl, Float Time)

	If(Ctrl == "Shout")
		If(time >= self.OptLongPressTime)
			;; long press on shout cancels mode.
			self.ControlModeSet(self.KeyModeNone)
		Else
			;; short press on shout.
		EndIf
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function OnControlDown_ModeMove(String Ctrl)

	Return
EndFunction

Function OnControlUp_ModeMove(String Ctrl, Float Time)

	If(Ctrl == "Shout")
		If(Time >= self.OptLongPressTime)
			;; long press on shout cancels.
			self.ControlModeSet(self.KeyModeNone)
		Else
			;; short press commands actor to go.
			self.ControlModeMoveCommand()
		EndIf
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function OnControlUp_ModeMoveObject(String Ctrl, Float Time)

	If(Ctrl == "Shout")
		If(Time >= self.OptLongPressTime)
			;; long press on shout cancels mode.
			self.ControlModeSet(self.KeyModeNone)
		Else
			;; move the object.
			self.ControlModeMoveObjectCommand()
		EndIf
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Behaviour API ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; These are the functions which will overwrite and manage the
;; overrides to an actors behaviour.

Function BehaviourApply(Actor Who, Package Pkg, Bool Restrain=FALSE)
{have an actor begin a specific package.}

	If(!self.ActorSexuallyValid(Who))
		Return
	EndIf

	;; remove the previous super package.

	Package OldPkg = StorageUtil.GetFormValue(Who,self.KeyActorPkg) as Package
	If(OldPkg != None)
		ActorUtil.RemovePackageOverride(Who,OldPkg)
	EndIf

	;; apply the new super package

	self.BehaviourRestrainSet(Who,FALSE)
	self.PoseTransformClear(Who)
	ActorUtil.AddPackageOverride(Who,Pkg,100)
	Who.EvaluatePackage()

	If(Pkg != self.dcc_dm_PackageFollow && Pkg != self.dcc_dm_PackageDoNothing && Pkg != self.dcc_dm_PackageDoNothingMovable)
		self.PoseTransformApply(Who,self.PoseTransformFind(Pkg))
	EndIf

	self.BehaviourPackageSet(Who,Pkg)

	If(Restrain)
		self.BehaviourRestrainSet(Who,TRUE)
	EndIf

	Return
EndFunction

Function BehaviourClear(Actor Who, Bool Full=FALSE)
{have an actor clear their ruling overwrite package. this will
automatically remove the persist hack actor as well when full
is true.}

	;; remove the superpackage.

	Package Pkg = self.BehaviourPackageGet(Who)
	If(Pkg != None)
		self.BehaviourPackageSet(Who,None)
		self.PoseTransformClear(Who)
		ActorUtil.RemovePackageOverride(Who,Pkg)
		Who.EvaluatePackage()
	EndIf

	If(self.ActorUsingGet(Who) != None)
		self.ActorUsingGet(Who).Enable(TRUE)
		self.ActorUsingSet(Who,None)
	EndIf

	self.ActorArousalUnregister(Who)
	If(!Full)
		Utility.Wait(0.1)
		self.AnimationReset(Who)
		Return
	EndIf

	;; remove the idle package.

	ActorUtil.RemovePackageOverride(Who,self.dcc_dm_PackageDoNothing)
	Who.EvaluatePackage()

	If(Who == self.Player)
		Game.SetPlayerAIDriven(FALSE)
	Else
		self.PersistHackClear(Who)
		self.BehaviourRestrainSet(Who,FALSE)
		self.ActorOutfitResume(Who)
	EndIf


	Who.RemoveFromFaction(self.dcc_dm_FactionControl)

	Utility.Wait(0.1)
	self.AnimationReset(Who)
	Return
EndFunction

Function BehaviourDefault(Actor Who)
{enforce the default ai behaviour of do nothing. this will
automatically apply the persist hack to the actor as well.}

	If(!self.ActorSexuallyValid(Who))
		Return
	EndIf

	self.BehaviourClear(Who,TRUE)

	If(Who == self.Player)
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven(TRUE)
	Else
		self.PersistHackApply(Who)
		self.BehaviourRestrainSet(Who,TRUE)
	EndIf

	Who.AddToFaction(self.dcc_dm_FactionControl)
	Who.SheatheWeapon()
	ActorUtil.AddPackageOverride(Who,self.dcc_dm_PackageDoNothing,99)
	Who.EvaluatePackage()
	Return
EndFunction

Package Function BehaviourPackageGet(Actor Who)
{get the current package.}
	
	Return StorageUtil.GetFormValue(Who,self.KeyActorPkg) as Package
EndFunction

Function BehaviourPackageSet(Actor Who, Package Pkg)
{sets the current package.}

	StorageUtil.SetFormValue(Who,self.KeyActorPkg,Pkg)
	Return
EndFunction

Bool Function BehaviourRestrainGet(Actor Who)
{get if restraint was needed}

	If(StorageUtil.GetIntValue(Who,self.KeyActorRestrain,Missing=0) == 1)
		Return TRUE
	EndIf

	Return FALSE
EndFunction

Function BehaviourRestrainSet(Actor Who, Bool Restrain)
{set if restraint was needed.}

	Int Val

	If(Restrain)
		Val = 1
		Who.SetDontMove(TRUE)
		Who.SetRestrained(TRUE)
		Who.SetHeadTracking(FALSE)
	Else
		Val = 0
		Who.SetDontMove(FALSE)
		Who.SetRestrained(FALSE)
		Who.SetHeadTracking(TRUE)
	EndIf

	StorageUtil.SetIntValue(Who,self.KeyActorRestrain,Val)
	Return
EndFunction

Bool Function BehaviourAllow(Actor Who, Bool Announce=TRUE)
{if an actor should be allowed to have their behaviour controlled.}

	Bool Allow = TRUE

	If(Allow && self.OptUseZazSlavery)
		zbfSlaveControl Zs = zbfSlaveControl.GetApi()
		If(Zs.IsSlave(Who))
			Allow = FALSE
		EndIf
	EndIf

	If(Announce && !Allow)
		;;
	EndIf

	Return Allow
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Persistence API ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; this is an amazing hack to make temporary actors stick around
;; for as long as we want them to. in the wrong hands this is
;; dangerous but i am awesome so its cool.

Function PersistHackApply(Actor Who)
{apply persistence hacks to keep temporary actors alive.}

	If(StorageUtil.FormListFind(None,self.KeyListPersist,Who) != -1)
		;; don't re-register if we are already in here.
		Return
	EndIf

	;; this is literally the hack.
	Who.RegisterForUpdate(600)
	;; in total.

	self.FormListLock(None,self.KeyListPersist,"PersistHackApply")
	StorageUtil.FormListAdd(None,self.KeyListPersist,Who,FALSE)
	self.FormListUnlock(None,self.KeyListPersist)

	;;self.PrintDebug(Who.GetDisplayName() + " persist applied")
	Return
EndFunction

Function PersistHackClear(Actor Who)
{clear the persistence hack. take into account known mods that also use this
same persistence hack (more or less, mine only, for the time being) so that
we don't fuck up those mods.}

	self.FormListLock(None,self.KeyListPersist,"PersistHackClear")
	StorageUtil.FormListRemove(None,self.KeyListPersist,Who,TRUE)
	self.FormListUnlock(None,self.KeyListPersist)

	;; SO I REMEMBER WHEN I DESIGNED THE FOLLOWING.
	;; it works well, but it is a maintenance nightmare. i think i will
	;; end up making a persistence framework that all my mods will use
	;; in the VERY near future. i dont really care if other modders use it
	;; but since all my mods need to implement the same hack i should
	;; abstract that

	;; mods need to track their persistance hacking via a global scope form
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
	FourthPartyList[1] = "SGO.ActorList.Persist" ;; Soulgem Oven 3

	Int CurrentMod = 0
	While(CurrentMod < FourthPartyList.Length)
		If(StorageUtil.FormListFind(None,FourthPartyList[CurrentMod],Who) != -1)
			;; if found in any of the fourth party lists then do not
			;; unregister it.
			;;self.PrintDebug(Who.GetDisplayName() + " persist kept for " + FourthPartyList[CurrentMod])
			Return
		EndIf

		CurrentMod += 1
	EndWhile

	Who.UnregisterForUpdate()
	;;self.PrintDebug(Who.GetDisplayName() + " persist cleared.")

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Actor API ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function ActorSexuallyValid(Actor Who)
{determine if we should disallow an actor for some reason.}

	If(self.OptValidateActor && !SexLab.IsValidActor(Who))
		self.Print(Who.GetDisplayName() + " is not SexLab Valid.")
		Return FALSE
	EndIf

	Return TRUE
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

ObjectReference Function ActorMarkerGet(Actor Who)
{fetch the marker that defines where this actor should be.}

	Return StorageUtil.GetFormValue(Who,self.KeyActorMarker) as ObjectReference
EndFunction

ObjectReference Function ActorMarkerPlaceAt(Actor Who, ObjectReference Where)
{place a marker for the actor at the specified location.}

	ObjectReference Marker = self.ActorMarkerGet(Who) as ObjectReference

	If(Marker != None)
		self.AlignObject(Marker,Where)
	Else
		Marker = Where.PlaceAtMe(self.StaticX,1,TRUE)
		self.AlignObject(Marker,Where)
		StorageUtil.SetFormValue(Who,self.KeyActorMarker,Marker)
	EndIf

	Return Marker
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

ObjectReference Function ActorUsingGet(Actor Who)
{get the object this actor is currently using}

	return StorageUtil.GetFormValue(Who,self.KeyActorUsing) as ObjectReference
EndFunction

Function ActorUsingSet(Actor Who, ObjectReference What)
{set an object (furniture) as being used by the actor. it will
disable the furniture and move the actor to its location. the
next step would be for you to trigger the idle package that
contains the animated equip version.}

	If(What == None)
		Who.RemoveFromFaction(self.dcc_dm_FactionUsingObject)

		;; were we using something before?
		What = self.ActorUsingGet(Who)
		If(What != None)
			What.Enable(FALSE)
		EndIf
	Else
		Who.AddToFaction(self.dcc_dm_FactionUsingObject)	
		What.Disable(FALSE)
		self.AlignObject(Who,What)
	EndIf

	StorageUtil.SetFormValue(Who,self.KeyActorUsing,What)
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function ActorOutfitStop(Actor Who, Bool Strip=TRUE)
{disable an actors original outfit, saving it for later.}

	ActorBase Base = Who.GetLeveledActorBase()
	Outfit Current1 = Base.GetOutfit(FALSE)
	Outfit Current2 = Base.GetOutfit(TRUE)

	If(Current1 == self.dcc_dm_OutfitNone)
		Return
	EndIf

	Base.SetOutfit(self.dcc_dm_OutfitNone,FALSE)
	Base.SetOutfit(self.dcc_dm_OutfitNone,TRUE)
	Who.AddToFaction(self.dcc_dm_FactionOutfit)

	If(Strip)
		Who.UnequipAll()
	EndIf

	StorageUtil.SetFormValue(Who,self.KeyActorOutfit1,Current1)
	StorageUtil.SetFormValue(Who,self.KeyActorOutfit2,Current2)
	Return
EndFunction

Function ActorOutfitResume(Actor Who)
{restore an actor's default outfit.}

	ActorBase Base = Who.GetLeveledActorBase()
	Outfit Original1 = StorageUtil.GetFormValue(Who,self.KeyActorOutfit1) as Outfit
	Outfit Original2 = StorageUtil.GetFormValue(Who,self.KeyActorOutfit2) as Outfit

	If(Original1 != None)
		Base.SetOutfit(Original1,FALSE)
		self.ActorOutfitEquip(Who,Original1)
		Who.RemoveFromFaction(self.dcc_dm_FactionOutfit)
	EndIf

	If(Original2 != None)
		Base.SetOutfit(Original2,TRUE)
	EndIf

	Return
EndFunction

Function ActorOutfitEquip(Actor Who, Outfit Items)
{equip an outfit part by part.}

	Int Count = Items.GetNumParts()

	;; assuming these are 0 indexed...

	While(Count > 0)
		Who.EquipItem(Items.GetNthPart(Count - 1))
		Count -= 1
	EndWhile

	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function ActorArousalRegister(Actor Who)
{register an actor to have its arousal modified, kicking off the processor that
will handle it if needed.}	

	Bool KickOff = FALSE

	If(Who != self.Player && !self.OptArousedNPC)
		Return
	EndIf

	If(StorageUtil.FormListCount(None,self.KeyListArousal) == 0)
		KickOff = TRUE
	EndIf
	
	StorageUtil.FormListAdd(None,self.KeyListArousal,Who,FALSE)
	Who.AddToFaction(self.dcc_dm_FactionAroused)

	If(KickOff)
		self.ArousalSystem.RegisterForSingleUpdate(30)
	EndIf

	Return
EndFunction

Function ActorArousalUnregister(Actor Who)
{remove actor from the arousal system. it will stop itself when it runs out of
things to do.}

	StorageUtil.FormListRemove(none,self.KeyListArousal,Who,TRUE)
	Who.RemoveFromFaction(self.dcc_dm_FactionAroused)
	Return
EndFunction

Float Function ActorArousalGetTick(Actor Who)
{determine how much the actor arousal should be modified per script tick.}

	If(Aroused == None)
		Return 0.0
	EndIf

	Float Tick = 1.0 * self.OptArousedTickFactor

	If(!Aroused.IsActorExhibitionist(Who))
		Tick *= -1.0
	EndIf

	Return Tick
EndFunction

Function ActorArousalUpdate(Actor Who)
{update an actors arousal.}

	Float Tick = self.ActorArousalGetTick(Who)

	If(Aroused && self.OptArousedTickExposure)
		;; exposure goes up if exhibitionist, down otherwise. that was decided
		;; by the tick value get function.
		self.PrintDebug(Who.GetDisplayName() + " Arousal Exposure Mod " + Tick)
		Aroused.UpdateActorExposure(Who,(Tick as Int)," Arousal Mod By DM2")
	EndIf

	If(Aroused && self.OptArousedTickTimeRate)
		;; time rate however always goes down.
		Float TimeRate = ((Math.Abs(Tick) / 4) * -1) 
		self.PrintDebug(Who.GetDisplayName() + " Arousal TimeRate " + StorageUtil.GetFloatValue(Who,"SLAroused.TimeRate") + " Mod " + TimeRate)
		;;Aroused.UpdateActorTimeRate(Who,TimeRate)
		StorageUtil.AdjustFloatValue(Who,"SLAroused.TimeRate",TimeRate)
		If(StorageUtil.GetFloatValue(Who,"SLAroused.TimeRate") < 0)
			StorageUtil.SetFloatValue(Who,"SLAroused.TimeRate",0.0)
		EndIf
	EndIf


	If(Who == self.Player)
		self.dcc_dm_SpellArousedFxNow.Cast(Who,Who)
	ElseIf(Who.Is3dLoaded())
		self.dcc_dm_SpellArousedFxOnDelay.Cast(Who,Who)
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function AnimationReset(Actor Who)
{send various events to reset various actors when we stuck them in animations.}

	Return Debug.SendAnimationEvent(Who,"IdleForceDefaultState")
EndFunction

Function AnimationPointDown(Actor Who)
{make the character point at this spot with authority.}

	Debug.SendAnimationEvent(Who,"ZapPointDown")
	Return
EndFunction

Function ImmersiveSoundMoan(Actor Who, Bool Hard=FALSE)
{play a moaning sound from the actor.}

	sslBaseVoice Voice = SexLab.PickVoice(Who)

	If(Hard)
		Voice.GetSound(100).Play(Who)
	Else
		Voice.GetSound(30).Play(Who)
	EndIf

	Return
EndFunction

sslBaseExpression Function ImmersiveExpression(Actor Who, Bool Enable)
{play an expression on the actor face.}

	If(Enable)
		sslBaseExpression E

		If(Utility.RandomInt(0,1) == 1)
			E = SexLab.GetExpressionByName("Shy")
		Else
			E = SexLab.GetExpressionByName("Pained")
		EndIf

		E.Apply(Who,50,Who.GetLeveledActorBase().GetSex())
		Return E
	Else
		sslBaseExpression.ClearMFG(Who)
	EndIf

	Return None
EndFunction

Function ImmersiveBlush(Actor Who, Float Opacity=1.0, Int FullTime=2, Float FadeTime=2.0)
{provide integration for Blush When Aroused. this will trigger a short blushing
event if installed http://www.loverslab.com/files/file/1724-blush-when-aroused}

	Int E = 0

	If(Who != self.Player)
		E = ModEvent.Create("BWA_ForceBlushOn")
	Else
		E = ModEvent.Create("BWA_ForceBlushOnPlr")
	Endif

	If(E == 0)
		self.PrintDebug("Blush Event Failure")
		Return
	EndIf

	If(Who != self.Player)
		ModEvent.PushForm(E,Who as Form)
	EndIf

	ModEvent.PushFloat(E,Opacity)
	ModEvent.PushInt(E,FullTime)
	ModEvent.PushFloat(E,FadeTime)
	ModEvent.PushBool(E,FALSE)
	ModEvent.Send(E)
	Return
EndFunction

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

Function SelfBondageEnable(Bool DoMenu=TRUE)
{trigger a self bondage scene, optionally showing the pose chooser.}

	self.UnequipShout(self.Player)
	self.BehaviourDefault(self.Player)
	Utility.Wait(0.15)

	If(DoMenu)
		;; control mode will handle registering for arousal.
		self.MenuPoseListSelector(self.Player)
	Else
		;; else we need to add it.
		self.ActorArousalRegister(self.Player)
	EndIf

	Return
EndFunction

Function SelfBondageDisable()
{stop a self bondage scene.}

	self.ControlModeSet(self.KeyModeNone)
	self.BehaviourClear(self.Player,TRUE)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; menu systems ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function MenuPoseListSelector(Actor Who)

	If(!self.ActorSexuallyValid(Who))
		Return
	EndIf

	UIListMenu Menu = UIExtensions.GetMenu("UIListMenu",TRUE) as UIListMenu
	String Result

	String[] Name = new String[12]
	FormList[] Pkg = new FormList[12]
	String[] Label = new String[12]

	Name[0] = "Caged"
	Pkg[0] = self.dcc_dm_ListPoseCage
	Name[1]  = "Chained"
	Pkg[1] = self.dcc_dm_ListPoseChain
	Name[2]  = "Cross"
	Pkg[2] = self.dcc_dm_ListPoseCross
	Name[3]  = "Crux"
	Pkg[3] = self.dcc_dm_ListPoseCrux
	Name[4] = "Doll Stand"
	Pkg[4] = self.dcc_dm_ListDollStand
	Name[5]  = "Misc Dungeon"
	Pkg[5] = self.dcc_dm_ListPoseMisc
	Name[6]  = "Pillory"
	Pkg[6] = self.dcc_dm_ListPosePillory
	Name[7]  = "Post"
	Pkg[7] = self.dcc_dm_ListPosePost
	Name[8]  = "Restrained Post/Wall"
	Pkg[8] = self.dcc_dm_ListPoseRestrainedTo
	Name[9]  = "Rope Bondage"
	Pkg[9] = self.dcc_dm_ListPoseRopeBondage
	Name[10]  = "Spit Roasted"
	Pkg[10] = self.dcc_dm_ListPoseSpitRoast
	Name[11] = "Submission"
	Pkg[11] = self.dcc_dm_ListPoseSubmit

	Menu.AddEntryItem("[[ Cancel ]]")

	Int Iter = 0
	While(Iter < Label.Length)
		Label[Iter] = self.FormListLabel(Name[Iter],Pkg[Iter])
		Menu.AddEntryItem(Label[Iter])

		Iter += 1
	EndWhile

	self.dcc_dm_ImodMenu.Apply(1.0)
	Utility.Wait(0.01)
	Menu.OpenMenu()
	self.dcc_dm_ImodMenu.Remove()

	Result = Menu.GetResultString()

	Iter = 0
	While(Iter < Label.Length)
		If(Result == Label[Iter])
			self.ControlModePoseStart(Who,Name[Iter],Pkg[iter])
			Return
		EndIf

		Iter += 1
	EndWhile

	Return
EndFunction
