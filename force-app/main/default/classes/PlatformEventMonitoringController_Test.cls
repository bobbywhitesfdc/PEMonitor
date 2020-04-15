@isTest(isParallel=true)
public class PlatformEventMonitoringController_Test {
    /**
     * SELECT Topic, ExternalId, Name, Position, Retries, Status, Tip, Type, LastError 
     * FROM EventBusSubscriber order by Topic, Name
     **/ 
    
    // Has Subscribers
    private static testmethod void testHappyPathVF() {
        if (PlatformEventMonitoringController.subscriptionInfo.isEmpty()) {
            PlatformEventMonitoringController.subscriptionInfo = loadFromStaticResource(); 
        }

        final List<EventBusSubscriber> results = PlatformEventMonitoringController.subscriptionInfo;
        System.Assert(results.size() > 0,'Expected 1 or more Subscriptions');
        for (EventBusSubscriber current : results) {
            System.AssertNotEquals(null,current.Topic,'Topic cannot be null');
            System.AssertNotEquals(null,current.Name,'Name cannot be null');
        }
    }

    private static testmethod void testHappyPathLWC() {
        if (PlatformEventMonitoringController.subscriptionInfo.isEmpty()) {
            PlatformEventMonitoringController.subscriptionInfo = loadFromStaticResource(); 
        }

        final List<PlatformEventMonitoringController.SubscriberInfo> results = PlatformEventMonitoringController.getSubscriberInfo();

        for (PlatformEventMonitoringController.SubscriberInfo current : results) {
            System.AssertNotEquals(null,current.topic,'Topic cannot be null');
            System.AssertNotEquals(null,current.subscriberName,'subscriberName cannot be null');
            System.AssertNotEquals(null,current.id,'Id cannot be null');
            System.AssertNotEquals(null,current.ExternalId,'ExternalId cannot be null');
            System.AssertNotEquals(null,current.uri,'Uri cannot be null');
        }
    }
    
    private static List<EventBusSubscriber> loadFromStaticResource() {
        final StaticResource sr = [SELECT Id, Body FROM StaticResource 
                                   WHERE Name = 'TestEventBusSubscriber' LIMIT 1];
		List<EventBusSubscriber> results = (List<EventBusSubscriber>) JSon.deserialize(sr.Body.toString(),List<EventBusSubscriber>.class);
        return results;
    }
}