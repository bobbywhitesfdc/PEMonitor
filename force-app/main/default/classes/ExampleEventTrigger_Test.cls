@isTest(isParallel=true)
public class ExampleEventTrigger_Test {
    private static testmethod void testTrigger() {
        
        Test.startTest();

        final List<ExampleEvent__e> exampleEvents = new List<ExampleEvent__e>();
        for(Integer i=0; i < 20; i++) {
            exampleEvents.add(new ExampleEvent__e(info__c='Message ' +i));
        }
        
        Eventbus.publish(exampleEvents);
        
        Test.stopTest();
        
        List<EventBusSubscriber> subscribers =[SELECT ExternalId, Name, Position, Status, Tip, Type
											   FROM EventBusSubscriber
											   WHERE Topic='ExampleEvent__e'];
        
        System.AssertNotEquals(0,subscribers.size(),'Events should have been published');
 
    }
}