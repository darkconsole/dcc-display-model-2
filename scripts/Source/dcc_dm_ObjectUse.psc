Scriptname dcc_dm_ObjectUse extends ObjectReference

Package Property IdlePackage Auto
MiscObject Property PickupItem Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnLoad()
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnActivate(ObjectReference Who)
{what to do when this object is interacted with.}

	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

	If(Who as Actor == None)
		Return
	Endif

	If(Who as Actor == DM.Player)
		DM.ControlModeSet(DM.KeyModeNone)

		Int Query = DM.dcc_dm_MsgUseObject.Show()

		If(Query == 0)
			self.OnActivate_Use(Who as Actor)
		ElseIf(Query == 1)
			self.OnActivate_Move(Who as Actor)
		ElseIf(Query == 2)
			self.OnActivate_PickUp(Who as Actor)
		EndIf
	Else
		self.OnActivate_Use(Who as Actor)
	EndIf

	Return
EndEvent

Function OnActivate_Use(Actor Who)

	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

	If(Who == DM.Player)
		DM.SelfBondageEnable(FALSE)
		DM.ActorUsingSet(Who as Actor, self)
		DM.BehaviourApply(Who as Actor, IdlePackage)
		self.RegisterForControl("Jump")
	Else
		DM.ActorUsingSet(Who as Actor, self)
		DM.BehaviourApply(Who as Actor, IdlePackage)
		DM.ActorArousalRegister(Who as Actor)
	EndIf

	Return
EndFunction

Function OnActivate_Move(Actor Who)

	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

	DM.ControlModeMoveObjectStart(self)
	Return
EndFunction

Function OnActivate_PickUp(Actor Who)

	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

	DM.ControlModeSet(DM.KeyModeNone)
	Who.AddItem(self.PickupItem,1)
	self.Disable(TRUE)
	self.Delete()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnControlUp(String Ctrl, Float Time)

		dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

		;; quit the controls.
		self.UnregisterForControl("Jump")

		;; return the player.
		DM.SelfBondageDisable()

		Return
EndEvent

