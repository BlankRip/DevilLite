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
    UInputAction MouseScrollWheelAction;
    UPROPERTY(Category = "Input")
    UInputMappingContext Context;

    UPROPERTY()
    ATopDownPlayer cachedTopDownPlayer;
    UPROPERTY(EditDefaultsOnly)
    float clickTimeThreshold = 0.5f;
    UPROPERTY(VisibleAnywhere)
    FVector cachedTargetDestination;

    private bool hitWalkiableInThisInputCycle;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        cachedTopDownPlayer = Cast<ATopDownPlayer>(GetControlledPawn());

        PushInputComponent(InputComponent);
        UEnhancedInputLocalPlayerSubsystem EnhancedInputSubsystem = UEnhancedInputLocalPlayerSubsystem::Get(this);
        EnhancedInputSubsystem.AddMappingContext(Context, 0, FModifyContextOptions());

        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_Triggered"));
        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Started, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_Started"));
        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Canceled, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_CompletedOrCanceled"));
        InputComponent.BindAction(SetDestinactionClickAction, ETriggerEvent::Completed, FEnhancedInputActionHandlerDynamicSignature(this, n"OnSetDestination_Click_CompletedOrCanceled"));
        
        InputComponent.BindAction(MouseScrollWheelAction, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"OnMouseScrollWheel_Triggered"));
    }

    UFUNCTION()
    void OnSetDestination_Click_Triggered(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction)
    {
        FVector location;
        GetLocationUnderCursor(hitWalkiableInThisInputCycle, location);
        if(hitWalkiableInThisInputCycle)
        {
            cachedTargetDestination = location;
            cachedTopDownPlayer.FollowLocation(cachedTargetDestination);
        }
    }

    UFUNCTION()
    void OnSetDestination_Click_Started(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction)
    {
        hitWalkiableInThisInputCycle = false;
        cachedTopDownPlayer.StopMovement();
    }
    
    UFUNCTION()
    void OnSetDestination_Click_CompletedOrCanceled(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction)
    {
        if(ElapsedTime < clickTimeThreshold && hitWalkiableInThisInputCycle)
        {
            cachedTopDownPlayer.MoveToLocation(cachedTargetDestination);
        }
    }

    UFUNCTION()
    void OnMouseScrollWheel_Triggered(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction)
    {
        cachedTopDownPlayer.ChangeCameraPostion(ActionValue.Axis1D);
    }

    UFUNCTION(BlueprintPure)
    void GetLocationUnderCursor(bool&out hit, FVector&out location)
    {
        FHitResult hitResult;
        GetHitResultUnderCursorByChannel(ETraceTypeQuery::WalkableArea, false, hitResult);
        hit = hitResult.bBlockingHit;
        location = hitResult.Location;
    }
}