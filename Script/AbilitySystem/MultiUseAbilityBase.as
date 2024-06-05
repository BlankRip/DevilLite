class MultiUseAbilityBase: AbilityBaseWithIntTracker
{
    void InitilizeAbility(ATopDownCharacter ownerCharacter, FAbilityCostData costData) override
    {
        Super::InitilizeAbility(ownerCharacter, costData);
        //So that when assigned to a slot can't immediatly use it
        SetRemainingUses(0);
        Super::StartCooldown();
        if(costData.MaxUses == 0)
        {
            PrintError("Max uses is 0, there is no point of using this as base class if you don't want multiple uses");
        }
    }

    protected void StartCooldownAndReduceUses()
    {
        StartCooldown();
        SetRemainingUses(tracker - 1);
    }

    void StartCooldown() override
    {
        if(tracker == cost.MaxUses)
        {
            Super::StartCooldown();
        }
    }

    void CancelCooldown() override
    {
        if(isInCooldown)
        {
            SetRemainingUses(tracker + 1);
            if(tracker == cost.MaxUses)
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
                SetRemainingUses(tracker + 1);
                if(tracker == cost.MaxUses)
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
                return (tracker > 0) && IsManaCostPassed();
            }
            else
            {
                PrintError("If multi use ability then it must have a cooldown, else there is no point of using this as base class");
                return false;
            }
        }
        return false;
    }

    protected void SetRemainingUses(int newValue)
    {
        int setValueTo = newValue;
        if(setValueTo < 0)
        {
            setValueTo = 0;
        }
        SetTrackerValue(setValueTo);
    }
}