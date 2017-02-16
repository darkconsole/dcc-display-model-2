;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname dcc_dm_PkgfChairBoundA1 Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
dcc_dm_QuestController DM = dcc_dm_QuestController.Get()
DM.BehaviourInteractionClear(akActor)
DM.BehaviourInteractionAdd(akActor,"Force Oral Service","dcc-dm-chairbound-a1-flavour2")
DM.BehaviourInteractionAdd(akActor,"Kneel & Fist","dcc-dm-chairbound-a1-flavour3")
DM.BehaviourInteractionAdd(akActor,"Kneel & Lick","dcc-dm-chairbound-a1-lick1")
DM.BehaviourInteractionAdd(akActor,"Sit Cross Legged","dcc-dm-chairbound-a1-sit1")
DM.BehaviourInteractionAdd(akActor,"Sit Cross Legged & Wiggle","dcc-dm-chairbound-a1-sit2")
DM.BehaviourInteractionAdd(akActor,"Sit & Finger","dcc-dm-chairbound-a1-flavour1")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
