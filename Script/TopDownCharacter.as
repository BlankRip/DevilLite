class ATopDownCharacter: ACharacter
{
    UPROPERTY(DefaultComponent)
    UFloatStatComponent HealthStatComponent;
    UPROPERTY(DefaultComponent)
    UFloatStatComponent ManaStatComponent;

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
}