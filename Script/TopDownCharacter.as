class ATopDownCharacter: ACharacter
{
    UPROPERTY()
    UNiagaraSystem cursorClickFX;

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
        Niagara::SpawnSystemAtLocation(cursorClickFX, targetLocation);
    }
}