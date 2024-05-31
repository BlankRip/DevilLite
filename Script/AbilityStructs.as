USTRUCT()
struct FAbilityData
{
    UPROPERTY()
    FAbilityUiData UiData;
    UPROPERTY()
    TSubclassOf<AbilityBase> AbilityClass;
    UPROPERTY()
    FAbilityCostData Cost;
}

struct FAbilityUiData
{
    UPROPERTY()
    const FString Name;
    UPROPERTY()
    const UTexture2D Image;
    UPROPERTY()
    const FString Description;
}

struct FAbilityCostData
{
    UPROPERTY()
    float ManaCost;
    UPROPERTY()
    bool HasCooldown;
    UPROPERTY()
    float CooldownTime;
}