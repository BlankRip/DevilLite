class ATopDownPlayerController: APlayerController
{
    default bShowMouseCursor = true;
    default bEnableClickEvents = true;
    default bEnableTouchEvents = false;
    default bEnableMouseOverEvents = true;
    UPROPERTY(DefaultComponent)
    UEnhancedInputComponent InputComponent;


    UPROPERTY(Category = "Input")
    UInputAction SetDestinactionClickAction;
    UPROPERTY(Category = "Input")
    UInputMappingContext Context;

    UPROPERTY()
    ATopDownCharacter cachedTopDownCharacter;
    UPROPERTY(EditDefaultsOnly)
    float clickTimeThreshold = 0.5f;
    UPROPERTY(VisibleAnywhere)
    FVector cachedTargetDestination;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        cachedTopDownCharacter = Cast<ATopDownCharacter>(GetControlledPawn());

        //InputComponent = Cast<UEnhancedInputComponent>(GetPlayerInput());
        PushInputComponent(InputComponent);
        UEnhancedInputLocalPlayerSubsystem EnhancedInputSubsystem = UEnhancedInputLocalPlayerSubsystem::Get(this);
        EnhancedInputSubsystem.AddMappingContext(Context, 0, FModifyContextOptions());

        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_Triggered"));
        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Started, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_Started"));
        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Canceled, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_CompletedOrCanceled"));
        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Completed, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_CompletedOrCanceled"));
    }

    UFUNCTION()
    void OnSetDestination_Click_Triggered(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction)
    {
        bool hit;
        FVector location;
        GetLocationUnderCursor(hit, location);
        if(hit)
        {
            cachedTargetDestination = location;
            cachedTopDownCharacter.FollowLocation(cachedTargetDestination);
        }
    }

    UFUNCTION()
    void OnSetDestination_Click_Started(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction)
    {
        StopMovement();
    }
    
    UFUNCTION()
    void OnSetDestination_Click_CompletedOrCanceled(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction)
    {
        if(ElapsedTime < clickTimeThreshold)
        {
            cachedTopDownCharacter.MoveToLocation(cachedTargetDestination);
        }
    }

    UFUNCTION(BlueprintPure)
    void GetLocationUnderCursor(bool&out hit, FVector&out location)
    {
        FHitResult hitResult;
        GetHitResultUnderCursorByChannel(ETraceTypeQuery::Visibility, false, hitResult);
        hit = hitResult.bBlockingHit;
        location = hitResult.Location;
    }
}