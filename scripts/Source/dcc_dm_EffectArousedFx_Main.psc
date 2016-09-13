Scriptname dcc_dm_EffectArousedFx_Main extends ActiveMagicEffect
{this script will play the sfx for arousal modifications on npcs at random
delays, so that the arousal processor which does them all at once wont have
them all sighing nsync.}

Bool Property Delay = TRUE Auto
{if we should do the delay.}

Float Property Low = 2.0 Auto
{minimum delay}

Float Property High = 30.0 Auto
{maximum delay}

Event OnEffectStart(Actor Who, Actor Caster)

	;; note - if you walk out of a load door while this function is still
	;; in the middle of waiting, there is a chance when you walk back in
	;; that their face will be frozen in an expression. it will correct itself
	;; the next time this runs on them. all the calls have to be wrapped with
	;; a 3d check, because a sexy expression stuck is a better option than
	;; filling the log with errors about missing animation data.

	If(!Who.Is3dLoaded())
		Return
	EndIf

	dcc_dm_QuestController Main = dcc_dm_QuestController.Get()

	;; perform a random delay so that all the actors do not sigh at the same
	;; time because that would be silly.
	If(self.Delay)
		Utility.Wait(Utility.RandomFloat(self.Low,self.High))
	EndIf

	;; trigger a blushing effect.
	If(Main.OptArousedTickBlush && Who.Is3dLoaded())
		Main.ImmersiveBlush(Who)
	EndIf

	;; trigger a seksy expression.
	If(Main.OptArousedTickExpression && Who.Is3dLoaded())
		Main.ImmersiveExpression(Who,TRUE)
	EndIf

	;; trigger an arousing sound.
	If(Main.OptArousedTickSound && Who.Is3dLoaded())
		Main.ImmersiveSoundMoan(Who,FALSE)
	EndIf

	;; give it a few seconds, then clear the expression out.
	If(Main.OptArousedTickExpression && Who.Is3dLoaded())
		Utility.Wait(3)
		Main.ImmersiveExpression(Who,FALSE)
	EndIf

	Return
EndEvent
