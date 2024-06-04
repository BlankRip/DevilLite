event void AbilityBase_ZeroParamsEvent();
event void AbilitBase_CooldownValueChangeEvent(float remainingTime, float normalizedValue);

class AbilityBase
{
    UPROPERTY()
    AbilityBase_ZeroParamsEvent OnCooldownStarted;
    UPROPERTY()
    AbilityBase_ZeroParamsEvent OnCooldownEnded;
    UPROPERTY()
    AbilitBase_CooldownValueChangeEvent OnCooldownValueChanged;

    bool ShouldRunTick;
    protected bool isInCooldown;
    protected float cooldownTimer;
    protected FAbilityCostData cost;
    protected ATopDownCharacter cachedTopDownCharacter;

    void InitilizeAbility(ATopDownCharacter ownerCharacter, FAbilityCostData costData)
    {
        isInCooldown = false;
        cooldownTimer = 0;
        cachedTopDownCharacter = ownerCharacter;
        cost = costData;
        ShouldRunTick = costData.HasCooldown;

        //So that when assigned to a slot can't immediatly use it
        StartCooldown();
    }

    void UseAbility()
    {
        //Override in child classes
    }

    void AbilityTick(float DeltaSeconds)
    {
        //Override in child classes
    }
    
    protected void StartCooldown()
    {
        if(cost.HasCooldown)
        {
            SetCooldownTimerValue(cost.CooldownTime);
            isInCooldown = true;
            OnCooldownStarted.Broadcast();
        }
    }

    void CancelCooldown()
    {
        if(cost.HasCooldown && isInCooldown)
        {
            SetCooldownTimerValue(0.f);
            isInCooldown = false;
        }
    }
    
    protected void HandleCooldownTimerOnTick(float DeltaSeconds)
    {
        if(isInCooldown)
        {
            SetCooldownTimerValue(cooldownTimer - DeltaSeconds);
            Print(String::Conv_DoubleToString(cooldownTimer), 0.f);
            if(cooldownTimer <= 0.f)
            {
                isInCooldown = false;
                OnCooldownEnded.Broadcast();
            }
        }
    }

    void ReduceCooldownBySetAmount(const float& amount)
    {
        if(isInCooldown)
        {
            SetCooldownTimerValue(cooldownTimer - amount);
        }
    }

    bool CanUseAbility()
    {
        if(cachedTopDownCharacter != nullptr)
        {
            if(cost.HasCooldown)
            {
                return IsCooldownCostPassed() && IsManaCostPassed();
            }
            else
            {
                return IsManaCostPassed();
            }
        }
        return false;
    }

    protected bool IsCooldownCostPassed()
    {
        return !isInCooldown;
    }

    protected bool IsManaCostPassed()
    {
        return cachedTopDownCharacter.ManaStatComponent.Value >= cost.ManaCost;
    }

    protected void SetCooldownTimerValue(float value)
    {
        cooldownTimer = value;
        if(cooldownTimer < 0.f)
        {
            cooldownTimer = 0.f;
        }
        OnCooldownValueChanged.Broadcast(cooldownTimer, cooldownTimer/cost.CooldownTime);
    }

    bool IsAbilityInCoolDown()
    {
        return isInCooldown;
    }

    bool HasCooldown()
    {
        return cost.HasCooldown;
    }
}