;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname dcc_dm_DiagCommand1 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE

dcc_dm_QuestController DM = dcc_dm_QuestController.Get()

If(akSpeaker.IsInFaction(DM.dcc_dm_FactionUsingObject))
	DM.Print(akSpeaker.GetDisplayName() + " is currently using a piece of furniture.")
	Return
EndIf

DM.ActorUsingSet(akSpeaker,None)
DM.BehaviourClear(akSpeaker)
akSpeaker.SetDoingFavor()


;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
