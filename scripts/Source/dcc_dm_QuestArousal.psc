Scriptname dcc_dm_QuestArousal extends Quest

dcc_dm_QuestController Property Main Auto

Event OnUpdate()

	;; drop any missings.
	Main.FormListFlushLost(None,Main.KeyListArousal)

	Form[] ActorList = StorageUtil.FormListToArray(None,Main.KeyListArousal)
	Int A = ActorList.Length

	While(A > 0)
		A -= 1

		If(ActorList[A] as Actor != None)
			Main.ActorArousalUpdate(ActorList[A] as Actor)
		EndIf
	EndWhile

	;; queue up another run if there are still people in the list.
	If(StorageUtil.FormListCount(None,Main.KeyListArousal) > 0)
		self.RegisterForSingleUpdate(30)
	EndIf

	Return
EndEvent

