class ATopDownCharacter: ACharacter
{
    UPROPERTY(DefaultComponent, Replicated, Category = "Top Down Character Specifics Components")
    UFloatStatComponent HealthStatComponent;
    UPROPERTY(DefaultComponent, Replicated, Category = "Top Down Character Specifics Components")
    UFloatStatComponent ManaStatComponent;
    UPROPERTY(DefaultComponent, Category = "Top Down Character Specifics Components")
    UAbilityComponent AbilityComponent;
    default bReplicates = true;

    UPROPERTY(Category = "Top Down Character Specifics")
    float basePerSecondManaRecoveryAmount = 10.f;


    UFUNCTION()
    void FollowLocation(const FVector& targetLocation)
    {
        FVector direction = targetLocation - GetActorLocation();
        direction.Normalize();
        AddMovementInput(direction);
        //AddMovementServerRPC(direction);
    }

    UFUNCTION(Server)
    void AddMovementServerRPC(const FVector& direction)
    {
        MovementComponent.AddInputVector(direction);

        //AddMovementInput(direction);
        Print(String::Conv_BoolToString(IsMoveInputIgnored()));
        Print(String::Conv_Int64ToString(LocalRole));
    }

    UFUNCTION()
    void MoveToLocation(const FVector& targetLocation)
    {
        MoveToLocationServerRPC(targetLocation);
        //Print(String::Conv_NameToString(GetController().Name));
        //Print(String::Conv_VectorToString(targetLocation));
    }

    UFUNCTION(Server)
    void MoveToLocationServerRPC(const FVector& targetLocation)
    {
        AIHelper::SimpleMoveToLocation(GetController(), targetLocation);
        //Print(String::Conv_NameToString(GetController().Name));
        //Print(String::Conv_VectorToString(targetLocation));
    }

    UFUNCTION()
    void StopMovement()
    {
        GetController().StopMovement();
    }

    UFUNCTION()
    void TakeDamage(float& damageAmount)
    {
        if(damageAmount > 0)
        {
            damageAmount *= -1;
        }
        HealthStatComponent.AddToValue(damageAmount);
    }

    UFUNCTION()
    void TakeDamageOverTimer(float& damageAmount, const float& overTimeInSeconds)
    {
        if(damageAmount > 0)
        {
            damageAmount *= -1;
        }
        HealthStatComponent.AddOverTime(damageAmount, overTimeInSeconds);
    }
}