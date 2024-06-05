event void AbilityBaseWithIntTracker_OneIntParamEvent(int remainingUses);

class AbilityBaseWithIntTracker: AbilityBase
{
    UPROPERTY()
    AbilityBaseWithIntTracker_OneIntParamEvent OnTrackerValueChanged;

    protected int tracker;

    protected void SetTrackerValue(int newValue)
    {
        tracker = newValue;
        OnTrackerValueChanged.Broadcast(tracker);
    }
} 