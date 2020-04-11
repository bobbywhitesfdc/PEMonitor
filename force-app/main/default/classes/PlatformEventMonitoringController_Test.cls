@isTest(isParallel=true)
public class PlatformEventMonitoringController_Test {
    /**
     * SELECT Topic, ExternalId, Name, Position, Retries, Status, Tip, Type, LastError 
     * FROM EventBusSubscriber order by Topic, Name
     **/ 
    
    // Has Subscribers
    private static testmethod void testHappyPath() {
        PlatformEventMonitoringController controller = new PlatformEventMonitoringController();
        final List<EventBusSubscriber> results = controller.subscriptionInfo;
        System.Assert(results.size() > 0,'Expected 1 or more Subscriptions');
        for (EventBusSubscriber current : results) {
            System.AssertNotEquals(null,current.Topic,'Topic cannot be null');
            System.AssertNotEquals(null,current.Name,'Name cannot be null');
        }
    }
}