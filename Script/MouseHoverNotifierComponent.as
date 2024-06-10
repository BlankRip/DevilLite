class UMouseHoverNotifierComponent: UBoxComponent
{
    UPROPERTY()
    UMouseHoverGlobalEvent mouseHoverEvent;
    UPROPERTY()
    EMouseHoverType mouseHoverType;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        if(mouseHoverEvent == nullptr)
        {
            PrintError("Mouse Hover Event Data asset is not provided, so none of the set up will take place inturn resulting in the component not working.");
            return;
        }

        OnBeginCursorOver.AddUFunction(this, n"BeginCursorOver");
        OnEndCursorOver.AddUFunction(this, n"EndCursorOver");
    }

    UFUNCTION()
    void BeginCursorOver(UPrimitiveComponent Component)
    {
        mouseHoverEvent.OnMouseHitRegesterObjectChanged.Broadcast(mouseHoverType);
    }

    UFUNCTION()
    void EndCursorOver(UPrimitiveComponent Component)
    {
        mouseHoverEvent.OnMouseHitRegesterObjectChanged.Broadcast(EMouseHoverType::Default_Walkable);
    }
}