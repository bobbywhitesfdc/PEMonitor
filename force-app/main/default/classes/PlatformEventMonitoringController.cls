/**
* Custom Controller to show Platform Events Subscriber Status
**/ 
public class PlatformEventMonitoringController {
    
    public PlatformEventMonitoringController() {
        
    }
    public static List<EventBusSubscriber> subscriptionInfo {
        get {return [SELECT Topic, ExternalId, Name, Position, Retries, Status, Tip, Type, LastError 
                     FROM EventBusSubscriber order by Topic, Name LIMIT 100]; }       
    }
    
    @AuraEnabled
    public static List<EventBusSubscriber> getInfo(){
        System.debug('getSubscriptionInfo:' + subscriptionInfo.size());
        return subscriptionInfo;
        
    }
}