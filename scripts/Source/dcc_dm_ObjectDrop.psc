ScriptName dcc_dm_ObjectDrop extends ObjectReference

Activator Property PlaceItem Auto
;; the item we want to put on the ground.

MiscObject Property Myself Auto
;; a referece to myself, because it turns out self is none on objects
;; which cannot be equipped even though we are still lolling around
;; with this OnEquipped event. it makes sense though, since its never
;; placed in the world.

Event OnEquipped(Actor Who)
	
	dcc_dm_QuestController DM = dcc_dm_QuestController.Get()
	ObjectReference Object
	ObjectReference HereMate

	DM.Player.RemoveItem(self.Myself,1)

	;; place a marker before we delay so the player can move and it
	;; still spawns in the right spot.
	HereMate = DM.Player.PlaceAtMe(DM.StaticX,1,TRUE,FALSE)
	DM.AlignObject(HereMate,DM.Player)

	;; this is the delay.
	;; we need the player to close the menu. and for the menu to be done
	;; animating otherwise there seems to be a high probability that it
	;; will never visually spawn in the world, even though its collision will.
	Debug.MessageBox("Close the menu to place " + self.Myself.GetName())
	Utility.Wait(0.1)

	;; then place the object at the location we dropped and make sure its
	;; angle didn't get lol'd by placeatme.
	Object = DM.Player.PlaceAtMe(self.PlaceItem,1,TRUE,TRUE)
	Object.SetActorOwner(DM.Player.GetLeveledActorBase())
	DM.AlignObject(Object,HereMate)

	Object.Enable(TRUE)
	HereMate.Disable(FALSE)
	HereMate.Delete()
	Return
EndEvent
