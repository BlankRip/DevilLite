class ATopDownCharacter: ACharacter
{
    UPROPERTY(DefaultComponent, Category = "Top Down Character Specifics Components")
    UFloatStatComponent HealthStatComponent;
    UPROPERTY(DefaultComponent, Category = "Top Down Character Specifics Components")
    UFloatStatComponent ManaStatComponent;
    UPROPERTY(DefaultComponent, Category = "Top Down Character Specifics Components")
    UAbilityComponent AbilityComponent;

    UPROPERTY(Category = "Top Down Character Specifics")
    float basePerSecondManaRecoveryAmount = 10.f;

    UFUNCTION()
    void FollowLocation(const FVector& targetLocation)
    {
        FVector direction = targetLocation - GetActorLocation();
        direction.Normalize();
        AddMovementInput(direction);
    }

    UFUNCTION()
    void MoveToLocation(const FVector& targetLocation)
    {
        MoveToLocationServerRPC(targetLocation);
        //Print(String::Conv_VectorToString(targetLocation));
    }

    UFUNCTION(Server)
    void MoveToLocationServerRPC(const FVector& targetLocation)
    {
        if(LocalRole == ENetRole::ROLE_Authority)
        {
            AIHelper::SimpleMoveToLocation(GetController(), targetLocation);
            
            //Print("Wanna know when this is triggered");
            //Print(String::Conv_VectorToString(targetLocation));
        }
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