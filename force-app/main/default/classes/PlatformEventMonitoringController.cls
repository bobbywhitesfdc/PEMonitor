/**
 * Custom Controller to show Platform Events Subscriber Status
 **/ 
public class PlatformEventMonitoringController {
    
    public PlatformEventMonitoringController() {
        
    }
    @auraEnabled
    public List<EventBusSubscriber> subscriptionInfo {
        get {return [SELECT Topic, ExternalId, Name, Position, Retries, Status, Tip, Type, LastError 
              FROM EventBusSubscriber order by Topic, Name LIMIT 100]; }       
    }
}