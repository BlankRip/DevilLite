class AbilityBase
{
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
        }
    }

    void CancelCooldown()
    {
        if(cost.HasCooldown)
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
            if(cooldownTimer <= 0.f)
            {
                isInCooldown = false;
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
                return isInCooldown && cachedTopDownCharacter.ManaStatComponent.Value > cost.ManaCost;
            }
            else
            {
                return cachedTopDownCharacter.ManaStatComponent.Value > cost.ManaCost;
            }
        }
        return false;
    }

    protected void SetCooldownTimerValue(float value)
    {
        cooldownTimer = value;
        if(cooldownTimer < 0.f)
        {
            cooldownTimer = 0.f;
        }
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