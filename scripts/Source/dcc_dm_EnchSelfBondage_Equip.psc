Scriptname dcc_dm_EnchSelfBondage_Equip Extends ActiveMagicEffect
{this script will toggle the binding every time it is equipped.}

dcc_dm_QuestController Property DM Auto

Event OnEffectStart(Actor To, Actor From)

	If(To == DM.Player)
		If(To.IsInFaction(DM.dcc_dm_FactionControl))
			DM.SelfBondageDisable()
		Else
			DM.SelfBondageEnable(TRUE)
			If(DM.OptTutorials)
				Debug.MessageBox("Unequip and Re-Equip this item to dismount.")
			EndIf
		EndIf
	EndIf

	Return
EndEvent
