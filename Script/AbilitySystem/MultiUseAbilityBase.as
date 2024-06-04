class MultiUseAbilityBase: AbilityBase
{
    protected int usesRemaining;

    void InitilizeAbility(ATopDownCharacter ownerCharacter, FAbilityCostData costData) override
    {
        Super::InitilizeAbility(ownerCharacter, costData);
        //So that when assigned to a slot can't immediatly use it
        SetUsesRemaining(0);
        Super::StartCooldown();
        if(costData.MaxUses == 0)
        {
            PrintError("Max uses is 0, there is no point of using this as base class if you don't want multiple uses");
        }
    }

    protected void StartCooldownAndReduceUses()
    {
        StartCooldown();
        SetUsesRemaining(usesRemaining - 1);
    }

    void StartCooldown() override
    {
        if(usesRemaining == cost.MaxUses)
        {
            Super::StartCooldown();
        }
    }

    void CancelCooldown() override
    {
        if(isInCooldown)
        {
            SetUsesRemaining(usesRemaining + 1);
            if(usesRemaining == cost.MaxUses)
            {
                SetCooldownTimerValue(0.f);
                isInCooldown = false;
            }
        }
    }

    void HandleCooldownTimerOnTick(float DeltaSeconds) override
    {
        if(isInCooldown)
        {
            SetCooldownTimerValue(cooldownTimer - DeltaSeconds);
            Print(String::Conv_DoubleToString(cooldownTimer), 0.f);
            if(cooldownTimer <= 0.f)
            {
                SetUsesRemaining(usesRemaining + 1);
                if(usesRemaining == cost.MaxUses)
                {
                    isInCooldown = false;
                    OnCooldownEnded.Broadcast();
                }
                else
                {
                    cooldownTimer = cost.CooldownTime;
                }
            }
        }
    }

    bool CanUseAbility() override
    {
        if(cachedTopDownCharacter != nullptr)
        {
            if(cost.HasCooldown)
            {
                return (usesRemaining > 0) && IsManaCostPassed();
            }
            else
            {
                PrintError("If multi use ability then it must have a cooldown, else there is no point of using this as base class");
                return false;
            }
        }
        return false;
    }

    protected void SetUsesRemaining(int newValue)
    {
        usesRemaining = newValue;
        if(usesRemaining < 0)
        {
            usesRemaining = 0;
        }
    }
}