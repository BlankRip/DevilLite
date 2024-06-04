event void AbilityComponent_UISetUpEvent(int slotIndex, FAbilityUiData abilityUiData);
event void AbilityComponent_UiCooldownSetUpEvent(int slotIndex, AbilityBase ability);
event void AbilityComponent_UiClearSlotEvent(int slotIndex, AbilityBase ability);

class UAbilityComponent: UActorComponent
{
    UPROPERTY()
    AbilityComponent_UISetUpEvent OnNewAbilitySlotedUiSetUpEvent;
    UPROPERTY()
    AbilityComponent_UiCooldownSetUpEvent OnNewAbilitySlotedUiCooldownSetUpEvent;
    UPROPERTY()
    AbilityComponent_UiClearSlotEvent OnAbilitySlotCleared;

    UPROPERTY()
    int MaxSlots = 6;
    UPROPERTY()
    UAbilityDataTable UsableAbilitiesTable;

    ATopDownCharacter ownerCharacter;
    TArray<FAbilitySlotData> AllSlots;
    private TArray<int> tickingAbilities;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        ownerCharacter = Cast<ATopDownCharacter>(GetOwner());
        if(ownerCharacter == nullptr)
        {
            PrintError("The abilily component must to be owned by a ATopDownCharacter");
        }

        AllSlots.Reserve(MaxSlots);
        for(int32 i = 0; i < MaxSlots; i++)
        {
            AllSlots.Add(FAbilitySlotData(i));
        }
        tickingAbilities.Reserve(MaxSlots);
    }
    
    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if(tickingAbilities.Num() > 0)
        {
            for(int slotIndex : tickingAbilities)
            {
                AllSlots[slotIndex].Ability.AbilityTick(DeltaSeconds);
            }
        }
    }

    UFUNCTION()
    void UseAbility(int slotIndex)
    {
        if(slotIndex >= MaxSlots)
        {
            PrintError("Slot index is greater than max ability slots");
            return;
        }

        if(!AllSlots[slotIndex].IsEmpty)
        {
            if(AllSlots[slotIndex].Ability.CanUseAbility())
            {
                AllSlots[slotIndex].Ability.UseAbility();
            }
        }
    }

    UFUNCTION()
    void UseAbilityWithoutCost(int slotIndex)
    {
        if(slotIndex >= MaxSlots)
        {
            PrintError("Slot index is greater than max ability slots");
            return;
        }

        if(!AllSlots[slotIndex].IsEmpty)
        {
            AllSlots[slotIndex].Ability.UseAbility();
        }
    }

    UFUNCTION()
    void AddAbility(int slotIndex, EAbilityName abilityDataTableRowName)
    {
        if(slotIndex >= MaxSlots)
        {
            PrintError("Slot index is greater than max ability slots");
            return;
        }
        if(!UsableAbilitiesTable.AbilitiesMap.Contains(abilityDataTableRowName))
        {
            PrintError("The ability requested is not avaible in the usable provided ability table");
            return;
        }

        if(!AllSlots[slotIndex].IsEmpty)
        {
            ClearAbilitySlot(slotIndex);
        }

        const FAbilityData& abilityData = UsableAbilitiesTable.AbilitiesMap[abilityDataTableRowName];
        AbilityBase ability = Cast<AbilityBase>(NewObject(this, abilityData.AbilityClass, FName(abilityData.UiData.Name)));

        OnNewAbilitySlotedUiSetUpEvent.Broadcast(slotIndex, abilityData.UiData);
        if(abilityData.Cost.HasCooldown)
        {
            OnNewAbilitySlotedUiCooldownSetUpEvent.Broadcast(slotIndex, ability);
        }
        
        AllSlots[slotIndex].Ability = ability;
        AllSlots[slotIndex].Ability.InitilizeAbility(ownerCharacter, abilityData.Cost);
        AllSlots[slotIndex].IsEmpty = false;
        if(ability.ShouldRunTick)
        {
            tickingAbilities.Add(slotIndex);
        }
    }

    UFUNCTION()
    void ClearAbilitySlot(int slotIndex)
    {
        if(slotIndex >= MaxSlots)
        {
            PrintError("Slot index is greater than max ability slots");
            return;
        }

        if(AllSlots[slotIndex].Ability.ShouldRunTick)
        {
            tickingAbilities.Remove(slotIndex);
        }
        OnAbilitySlotCleared.Broadcast(slotIndex, AllSlots[slotIndex].Ability);
        AllSlots[slotIndex].Ability = nullptr;
        AllSlots[slotIndex].IsEmpty = true;
    }
}

struct FAbilitySlotData
{
    UPROPERTY()
    bool IsEmpty;
    UPROPERTY()
    int SlotIndex;
    UPROPERTY()
    AbilityBase Ability;

    FAbilitySlotData(int index)
    {
        SlotIndex = index;
        IsEmpty = true;
    }

    FAbilitySlotData(int index, AbilityBase ability)
    {
        SlotIndex = index;
        Ability = ability;
        IsEmpty = false;
    }
}