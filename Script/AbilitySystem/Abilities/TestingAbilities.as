class TestingAbilityA: AbilityBase
{
    
    void UseAbility() override
    {
        Print("Arrows Fired, I Repeat Arrows Fired");
        StartCooldown();
    }

    void AbilityTick(float DeltaSeconds) override
    {
        HandleCooldownTimerOnTick(DeltaSeconds);
    }
}

class TestingAbilityB: AbilityBase
{
    void UseAbility() override
    {
        Print("Sword Slashed, Arrow in foot");
        cachedTopDownCharacter.ManaStatComponent.AddToValue(-cost.ManaCost);
    }
}

class TestingAbilityC: AbilityBase
{
    void UseAbility() override
    {
        Print("Hammer Slashed, NO SLAMMED...");
        cachedTopDownCharacter.ManaStatComponent.AddToValue(-cost.ManaCost);
        StartCooldown();
    }

    void AbilityTick(float DeltaSeconds) override
    {
        HandleCooldownTimerOnTick(DeltaSeconds);
    }
}