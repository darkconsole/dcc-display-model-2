ScriptName dcc_dm_EffectAnimationLock_Main Extends ActiveMagicEffect
{set marker, apply this, trigger animation.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_dm_QuestController Property Main Auto
{access to the main display model api.}

Actor Property Who Auto
{remember who we are talking about.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor To, Actor From)
{pose lawk}

	ObjectReference Here = Main.ActorMarkerGet(To)
	Float[] Transform = new Float[3]

	self.Who = To
	Transform[0] = 0.0
	Transform[1] = 0.0
	Transform[2] = 0.0

	;; the target's marker should have been set prior to the
	;; application of this lock.

	To.SetVehicle(Here)
	Main.PoseTransformApply(Who,Transform)
	Main.AlignObject(To,Here)

	;; helloslomoroto

	To.SplineTranslateTo(Here.GetPositionX(),Here.GetPositionY(),Here.GetPositionZ(),Here.GetAngleX(),Here.GetAngleY(),(Here.GetAngleZ() + 0.01),1.0,500,0.001)

	;; provide an escape mechanism.

	self.RegisterForControl("Jump")

	Return
EndEvent

Event OnEffectFinish(Actor To, Actor From)
{pose unlawk}

	;; happened automatically at the destruction of the mgef.
	;; self.UnregisterForControl("Jump")

	To.StopTranslation()
	To.SetVehicle(None)
	Main.PoseTransformClear(Who)

	;; don't reset the npc, they are the ones still in bondage...

	If(To == Main.Player)
		Debug.SendAnimationEvent(To,"IdleForceDefaultState")
		Main.MoveObjectByVector(To,Main.ActorMarkerGet(To))
	EndIf
	
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnControlDown(String Ctrl)
{bam mofo}

	If(Ctrl == "Jump")
		;;If(self.Who != Main.Player)
		;;	Utility.Wait(10)
		;;EndIf

		self.Who.RemoveSpell(Main.dcc_dm_SpellAnimationLock)
	EndIf

	Return
EndEvent

