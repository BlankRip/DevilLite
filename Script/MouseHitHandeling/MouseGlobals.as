event void GlobalCursorEvent_OnMouseHitRegesterHoverObjectChanged(EMouseHoverType mouseHoverType);

class UMouseHoverGlobalEvent: UDataAsset
{
    UPROPERTY()
    GlobalCursorEvent_OnMouseHitRegesterHoverObjectChanged OnMouseHitRegesterObjectChanged;
}

enum EMouseHoverType
{
    Default_Walkable,
    Interactable,
    Attackable
}