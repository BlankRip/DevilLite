class ATopDownCharacter: ACharacter
{
    UPROPERTY(DefaultComponent, Category = "Top Down Character Specifics Components")
    UFloatStatComponent HealthStatComponent;
    UPROPERTY(DefaultComponent, Category = "Top Down Character Specifics Components")
    UFloatStatComponent ManaStatComponent;

    UPROPERTY(Category = "Top Down Character Specifics")
    float basePerSecondManaRecoveryAmount;

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
        AIHelper::SimpleMoveToLocation(GetController(), targetLocation);
    }

    UFUNCTION()
    void StopMovement()
    {
        GetController().StopMovement();
    }
}