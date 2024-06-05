class URadialProgressBar: UUserWidget
{
    UPROPERTY(meta = "BindWidget")
    UImage RadialProgressBar;
    UPROPERTY()
    UMaterialInstance ProgressBarMaterial;

    private bool initilized;
    UMaterialInstanceDynamic materialInstance;

    UFUNCTION(BlueprintOverride)
    void Construct()
    {
        CreateMaterialInstance();
        SetPercentage(1.0f);
    }

    private void CreateMaterialInstance()
    {
        if(!initilized)
        {
            materialInstance = Material::CreateDynamicMaterialInstance(ProgressBarMaterial);
            RadialProgressBar.SetBrushFromMaterial(materialInstance);
            initilized = true;
        }
    }

    UFUNCTION()
    void SetPercentage(float value)
    {
        if(initilized)
        {
            materialInstance.SetScalarParameterValue(FName("Percentage"), value);
        }
    }
}