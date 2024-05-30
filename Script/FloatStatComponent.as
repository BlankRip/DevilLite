class UFloatStatComponent: UActorComponent
{
    UPROPERTY()
    private FVector2D MinMaxVaule = FVector2D(0.f, 100.f);

    float Value;
    default Value = MinMaxVaule.Y;
    private float ConstantRecoveryAmount;
    private TArray<OverTimeFloatModification> OverTimeModifiers;
    default OverTimeModifiers.Reserve(15);


    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        HandleConstantRecovery(DeltaSeconds);
        HandleOverTimeModifications(DeltaSeconds);
        Print(this.GetName() + ":\n" + String::Conv_DoubleToString(Value), 0);
    }

    private void HandleOverTimeModifications(const float& DeltaSeconds)
    {
        if(OverTimeModifiers.Num() > 0)
        {
            float debugValue = GetExpectedValueAfterOvertimeModifications();
            Print(String::Conv_DoubleToString(debugValue), 0, FLinearColor::Purple);
            for (int32 index = OverTimeModifiers.Num() - 1; index >= 0; index--)
            {
                AddToValue(OverTimeModifiers[index].GetThisFarmModificationAmount(DeltaSeconds));
                if(OverTimeModifiers[index].IsModificationComplete())
                {
                    OverTimeModifiers.RemoveAt(index);
                }
            }
        }
    }

    private void HandleConstantRecovery(const float& DeltaSeconds)
    {
        if(ConstantRecoveryAmount > 0 && Value < MinMaxVaule.Y)
        {
            AddToValue(ConstantRecoveryAmount * DeltaSeconds);
        }
    }

    UFUNCTION()
    void AddToValue(const float& amount)
    {
        Value += amount;
        ClampValueToLimits();
    }

    private void ClampValueToLimits()
    {
        if(Value > MinMaxVaule.Y)
        {
            Value = MinMaxVaule.Y;
        }
        else if (Value < MinMaxVaule.X)
        {
            Value = MinMaxVaule.X;
        }
    }

    UFUNCTION()
    void AddOverTime(float& amountToAdd, const float& overDuration)
    {
        bool isNegetiveModification = false;
        if(amountToAdd < 0.f)
        {
            isNegetiveModification = true;
            amountToAdd *= -1;
        }

        OverTimeModifiers.Add(OverTimeFloatModification(amountToAdd, overDuration, isNegetiveModification));
    }

    UFUNCTION()
    void RemoveAllOverTimeModifications()
    {
        for (int32 index = OverTimeModifiers.Num() - 1; index >= 0; index--)
        {
            OverTimeModifiers[index].ForceEndModification();
            OverTimeModifiers.RemoveAt(index);
        }
    }

    UFUNCTION()
    float GetExpectedValueAfterOvertimeModifications()
    {
        float expectedValue = Value;
        for (auto& modifier : OverTimeModifiers)
        {
            expectedValue += modifier.GetRemainingModificationValue();
        }

        if(expectedValue > MinMaxVaule.Y)
        {
            expectedValue = MinMaxVaule.Y;
        }
        else if (expectedValue < MinMaxVaule.X)
        {
            expectedValue = MinMaxVaule.X;
        }
        return expectedValue;
    }

    UFUNCTION()
    void SetConstantRecoveryPerSecond(const float& amount)
    {
        ConstantRecoveryAmount = amount;
    }

    UFUNCTION()
    void AddToConstantRecoveryPerSecond(const float& amount)
    {
        ConstantRecoveryAmount += amount;
        if(ConstantRecoveryAmount < 0.f)
        {
            ConstantRecoveryAmount = 0.f;
        }
    }
}

class OverTimeFloatModification
{
    private float ModificationPerSecond;
    private float ModificationAmountLeft;
    private int ModificationSign;

    OverTimeFloatModification(float modificationAmount, float modificationDuration, bool isNegetiveModification)
    {
        ModificationPerSecond = modificationAmount/modificationDuration;
        ModificationAmountLeft = modificationAmount;
        if(isNegetiveModification)
        {
            ModificationSign = -1;
        }
        else
        {
            ModificationSign = 1;
        }
    }

    float GetThisFarmModificationAmount(const float& DeltaSeconds)
    {
        if(IsModificationComplete())
        {
            Print("Modification is complete, forgot to do clean up");
            return 0.f;
        }

        float amountThisFrame = ModificationPerSecond * DeltaSeconds;
        if(amountThisFrame > ModificationAmountLeft)
        {
            amountThisFrame = ModificationAmountLeft;
        }
        ModificationAmountLeft -= amountThisFrame;
        return amountThisFrame * ModificationSign;
    }

    bool IsModificationComplete()
    {
        return ModificationAmountLeft <= 0.f;
    }

    float GetRemainingModificationValue()
    {
        return ModificationAmountLeft * ModificationSign;
    }

    void ForceEndModification()
    {
        ModificationAmountLeft = 0.f;
    }
}