;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname dcc_dm_DiagCome1 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE

If(!akSpeaker.IsInFaction(DM.dcc_dm_FactionControl))
	DM.BehaviourDefault(akSpeaker)
	Utility.Wait(1.0)
EndIf

DM.ActorUsingSet(akSpeaker,None)
DM.BehaviourApply(akSpeaker,DM.dcc_dm_PackageFollow)
DM.AnimationReset(akSpeaker)

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

dcc_dm_QuestController Property DM  Auto  
