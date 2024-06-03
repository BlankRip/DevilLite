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

    UPROPERTY(VisibleAnywhere)
    UAbilityComponent attachedAbilityComponent;

    void InitilizeWithAbilityComponent(UAbilityComponent abilityComponent)
    {
        attachedAbilityComponent = abilityComponent;
        CooldownPanel.SetVisibility(ESlateVisibility::Hidden);
    }
}