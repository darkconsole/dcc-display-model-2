Scriptname dcc_dm_EnchSelfBondage_Equip Extends ActiveMagicEffect
{this script will toggle the binding every time it is equipped.}

dcc_dm_QuestController Property DM Auto

Event OnEffectStart(Actor To, Actor From)

	If(To == DM.Player)
		If(To.IsInFaction(DM.dcc_dm_FactionControl))
			DM.SelfBondageDisable()
		Else
			DM.SelfBondageEnable(TRUE)
		EndIf
	EndIf

	Return
EndEvent
