Scriptname dcc_dm_ObjectUse extends ObjectReference

Package Property IdlePackage Auto
MiscObject Property PickupItem Auto

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
		(Who as Actor).SetDoingFavor(FALSE)
	EndIf

	Return
EndEvent

Function OnActivate_Use(Actor Who)
{when this object is selected for use by an actor.}

	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

	If(Who == DM.Player)
		DM.SelfBondageEnable(FALSE)
		DM.ActorUsingSet(Who, self)
		DM.BehaviourApply(Who, self.IdlePackage, FALSE)
		self.RegisterForControl("Jump")

		If(DM.OptTutorials)
			Debug.MessageBox("Press JUMP to escape.")
		EndIf
	Else
		DM.ActorArousalRegister(Who)
		DM.ActorUsingSet(Who, self)
		DM.BehaviourApply(Who, self.IdlePackage, TRUE)
	EndIf

	DM.ActorBondageTimeStart(Who)
	DM.ActorMarkerPlaceAt(Who,Who,TRUE)
	Return
EndFunction

Function OnActivate_Move(Actor Who)
{when this object is selected to be moved by the player.}

	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

	DM.ControlModeMoveObjectStart(self)
	Return
EndFunction

Function OnActivate_PickUp(Actor Who)
{when this object is selected to be picked up by the player.}

	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()
	DM.ControlModeSet(DM.KeyModeNone)

	;; give the player one.
	Who.AddItem(self.PickupItem,1)

	;; then kill off the one in the game world.
	self.Disable(TRUE)
	self.Delete()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnControlUp(String Ctrl, Float Time)
{if the player used this device then we watch for the jump command to
release them from it.}

		dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

		If(DM.OptForceBondageTime > 0)
			Float TimeDiff = Utility.GetCurrentRealTime() - StorageUtil.GetFloatValue(DM.Player,"DM2.Actor.BondageClientStart",0.0)
			Int EscapeRoll = Utility.RandomInt(1,99)

			DM.PrintDebug("Bondage Enforcement Enabled")

			If(DM.Player.GetActorValue("Stamina") < DM.OptEscapeBondageStamina)
				DM.Print("You are too tired to escape.")
				DM.Player.DamageActorValue("Stamina",DM.OptEscapeBondageStamina)
				Return
			EndIf

			DM.Player.DamageActorValue("Stamina",DM.OptEscapeBondageStamina)

			If(TimeDiff < DM.OptForceBondageTime)
				DM.PrintDebug("Bondage Enforced (" + DM.OptEscapeBondageChance + "%, " + EscapeRoll + ")")

				If(EscapeRoll >= DM.OptEscapeBondageChance)
					DM.Print("Your escape attempt fails. It has only been " + (TimeDiff / 60.0) + " minutes.")

					If(DM.OptEscapeBondageFailArouse)
						DM.ActorArousalUpdate(DM.Player, FALSE)
					EndIf

					Return
				EndIf
			EndIf
		EndIf

		DM.Print("You have freed yourself from the restraints.")

		;; quit the controls.
		self.UnregisterForControl("Jump")

		;; return the player.
		DM.SelfBondageDisable()

		Return
EndEvent

