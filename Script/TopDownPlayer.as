class ATopDownPlayer: ATopDownCharacter
{
    UPROPERTY(DefaultComponent, Category = "Player Specifics")
    USpringArmComponent CameraSpringArm;
    default CameraSpringArm.WorldRotation = FRotator(-50, 0, 0);
    default CameraSpringArm.TargetArmLength = 1400.0f;
    default CameraSpringArm.bDoCollisionTest = false;
    UPROPERTY(DefaultComponent, Attach = CameraSpringArm, Category = "Player Specifics")
    UCameraComponent PlayerCamera;
    default PlayerCamera.FieldOfView = 55.0f;

    UPROPERTY(Category = "Player Specifics")
    UNiagaraSystem cursorClickFX;

    private bool cameraLerping;
    UPROPERTY(Category = "Player Specifics")
    private const float cameraLerpTime = 0.5f;
    UPROPERTY(Category = "Player Specifics")
    private FVector2D cameraSpringArmEndLerpPoints = FVector2D(800.f, 1400.f);
    private float cameraLerpTimer;
    private FVector2D lerpEndPoints;
    private const int regesterChangeCameraThreshold = 1;
    private int changeCameraInputValue;

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        HandleCameraLerp(DeltaSeconds);
    }

    private void HandleCameraLerp(float DeltaSeconds)
    {
        if(cameraLerping)
        {
            cameraLerpTimer += DeltaSeconds;
            float lerpValue = cameraLerpTimer/cameraLerpTime;
            if(lerpValue >= 1.f)
            {
                lerpValue = 1.f;
                cameraLerping = false;
            }
            CameraSpringArm.TargetArmLength = Math::Lerp(lerpEndPoints.X, lerpEndPoints.Y, lerpValue);
        }
    }

    void ChangeCameraPostion(const float& inputValue)
    {
        if(cameraLerping)
        {
            return;
        }

        if(inputValue > 0.2f)
        {
            if(changeCameraInputValue < 0)
            {
                changeCameraInputValue = 0;
            }
            UpdateChangeCameraInputValue(1.f, regesterChangeCameraThreshold, cameraSpringArmEndLerpPoints.X);
        }
        else if(inputValue < -0.2f)
        {
            if(changeCameraInputValue > 0)
            {
                changeCameraInputValue = 0;
            }
            UpdateChangeCameraInputValue(-1.f, -regesterChangeCameraThreshold, cameraSpringArmEndLerpPoints.Y);
        }
    }

    private void UpdateChangeCameraInputValue(const float& addAmount, const float& thresholdValue, const float& lerpTarget)
    {
        changeCameraInputValue += addAmount;
        bool crossThreshold = (thresholdValue < 0.f) ? (changeCameraInputValue < thresholdValue) : (changeCameraInputValue > thresholdValue);
        if(crossThreshold)
        {
            if(CameraSpringArm.TargetArmLength != lerpTarget)
            {
                lerpEndPoints = FVector2D(CameraSpringArm.TargetArmLength, lerpTarget);
                cameraLerpTimer = 0.f;
                cameraLerping = true;
            }
            else
            {
                changeCameraInputValue = 0;
            }
        }
    }

    
    void MoveToLocation(const FVector& targetLocation) override
    {
        Super::MoveToLocation(targetLocation);
        Niagara::SpawnSystemAtLocation(cursorClickFX, targetLocation);
    }
}