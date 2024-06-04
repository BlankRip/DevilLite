class UAbilitySlotUserWidget: UUserWidget
{
    UPROPERTY(meta = "BindWidget")
    UImage AbilityIcon;
    UPROPERTY(meta = "BindWidget")
    UTextBlock NumberOfUsesText;

    UPROPERTY(meta = "BindWidget")
    UPanelWidget CooldownPanel;
    UPROPERTY(meta = "BindWidget")
    UProgressBar CooldownProgressBar;
    UPROPERTY(meta = "BindWidget")
    UTextBlock CooldownText;

    UPROPERTY(meta = "BindWidget")
    UTextBlock KeybindText;

    UPROPERTY()
    int uiSlotIndex = 0;
    UPROPERTY(VisibleAnywhere)
    UAbilityComponent attachedAbilityComponent;
    private bool usingCooldown;

    //Probaly not need the below viriable stored but keeping for now
    UPROPERTY(VisibleAnywhere)
    FAbilityUiData attachedUiData;

    UFUNCTION()
    void InitilizeWithAbilityComponent(UAbilityComponent abilityComponent)
    {
        usingCooldown = false;
        attachedAbilityComponent = abilityComponent;
        KeybindText.SetText(FText::FromString(String::Conv_IntToString(uiSlotIndex)));
        CooldownPanel.SetVisibility(ESlateVisibility::Hidden);
        NumberOfUsesText.SetVisibility(ESlateVisibility::Hidden);

        attachedAbilityComponent.OnNewAbilitySlotedUiSetUpEvent.AddUFunction(this, n"SetUpAbililtyUIVisuals");
        attachedAbilityComponent.OnAbilitySlotCleared.AddUFunction(this, n"ClearAbilityUiVisual");
    }

    UFUNCTION()
    void SetUpAbililtyUIVisuals(const int& slotIndex, const FAbilityUiData& uiData)
    {
        if(slotIndex == uiSlotIndex)
        {
            attachedUiData = uiData;
            AbilityIcon.SetBrushFromTexture(attachedUiData.Image);
        }
    }

    UFUNCTION()
    void ClearAbilityUiVisual(const int& slotIndex, const AbilityBase& ability)
    {
        if(slotIndex == uiSlotIndex)
        {
            AbilityIcon.SetBrushFromTexture(nullptr);

            if(CooldownPanel.GetVisibility() != ESlateVisibility::Hidden)
            {
                CooldownPanel.SetVisibility(ESlateVisibility::Hidden);
            }
        }
    }
}