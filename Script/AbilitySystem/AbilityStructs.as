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
    UTexture2D Image;
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

class UAbilityDataTable: UDataAsset
{
    UPROPERTY()
    TMap<EAbilityName, FAbilityData> AbilitiesMap;
}

enum EAbilityName
{
    Default_NotToBeUsed,
    TestingAbility1,
    TestingAbility2,
    TestingAbility3
}