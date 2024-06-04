event void MultiUseAbilityBase_OneIntParamEvent(int remainingUses);

class MultiUseAbilityBase: AbilityBase
{
    UPROPERTY()
    MultiUseAbilityBase_OneIntParamEvent OnRemainingUsesChanged;

    protected int remainingUses;

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
        SetRemainingUses(remainingUses - 1);
    }

    void StartCooldown() override
    {
        if(remainingUses == cost.MaxUses)
        {
            Super::StartCooldown();
        }
    }

    void CancelCooldown() override
    {
        if(isInCooldown)
        {
            SetRemainingUses(remainingUses + 1);
            if(remainingUses == cost.MaxUses)
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
                SetRemainingUses(remainingUses + 1);
                if(remainingUses == cost.MaxUses)
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
                return (remainingUses > 0) && IsManaCostPassed();
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
        remainingUses = newValue;
        if(remainingUses < 0)
        {
            remainingUses = 0;
        }
        OnRemainingUsesChanged.Broadcast(remainingUses);
    }
}