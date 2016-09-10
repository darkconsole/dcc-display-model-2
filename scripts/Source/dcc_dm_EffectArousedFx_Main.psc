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

	If(!Who.Is3dLoaded())
		Return
	EndIf

	dcc_dm_QuestController Main = dcc_dm_QuestController.Get()

	If(self.Delay)
		Utility.Wait(Utility.RandomFloat(self.Low,self.High))
	EndIf

	If(Main.OptArousedTickBlush)
		Main.ImmersiveBlush(Who)
	EndIf

	If(Main.OptArousedTickExpression)
		Main.ImmersiveExpression(Who,TRUE)
	EndIf

	If(Main.OptArousedTickSound)
		Main.ImmersiveSoundMoan(Who,FALSE)
	EndIf

	If(Main.OptArousedTickExpression)
		Utility.Wait(3)
		Main.ImmersiveExpression(Who,FALSE)
	EndIf

	Return
EndEvent
