class UMajorStatFillUserWidget: UUserWidget
{
    UPROPERTY(meta = (BindWidget))
    UProgressBar FillProgressBar;
    UPROPERTY(meta = (BindWidget))
    UProgressBar ExpectedFillProgressBar;

    UPROPERTY(VisibleAnywhere)
    UFloatStatComponent attachedStatComponent;

    UFUNCTION()
    void InitilizeWithFloatState(UFloatStatComponent floatStateComponent)
    {
        attachedStatComponent = floatStateComponent;
        attachedStatComponent.OnValueChangeNormalized.AddUFunction(this, n"OnStatValueChangedNormalized");
        ExpectedFillProgressBar.Percent = 0.f;
        FillProgressBar.Percent = 1.f;
    }

    UFUNCTION()
    void OnStatValueChangedNormalized(const float& newNormalizedValue)
    {
        if(attachedStatComponent.HasOverTimeModifications())
        {
            ExpectedFillProgressBar.Percent = newNormalizedValue;
            FillProgressBar.Percent = attachedStatComponent.GetNormalizedExpectedValueAfterOvertimeModifications();
        }
        else
        {
            ExpectedFillProgressBar.Percent = 0.f;
            FillProgressBar.Percent = newNormalizedValue;
        }
    }
}