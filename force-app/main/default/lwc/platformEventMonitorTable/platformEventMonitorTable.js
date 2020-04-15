import { LightningElement, wire, track } from 'lwc';
import getSubscriberInfo from '@salesforce/apex/PlatformEventMonitoringController.getSubscriberInfo';

const columnsDef = [
    { label: 'Topic', fieldName: 'topic' },
    { label: 'Subscriber', fieldName: 'uri', type: 'url'
        , typeAttributes: {label: { fieldName: 'subscriberName' }, target: '_blank'},},
    { label: 'Type', fieldName: 'type' },
    { label: 'Position', fieldName: 'position', type: 'number', fixedWidth: '80px'},
    { label: 'Tip', fieldName: 'tip', type: 'number', fixedWidth: '80px'},
    { label: 'Status', fieldName: 'status' },
    { label: 'Retries', fieldName: 'retries', type: 'number' ,fixedWidth: '80px'},
    { label: 'Last Error', fieldName: 'lastError', wrapText: 'true'},
];


export default class PlatformEventMonitorTable extends LightningElement {
    @wire(getSubscriberInfo) subscriberInfo;
    @track columns = columnsDef;

    get errorMessages() {
        let errors = this.subscriberInfo.error;

        /* Below logic is borrowed from ldsUtils.js in lwc-recipes */
        if (!Array.isArray(errors)) {
            errors = [errors];
        }

        return (
            errors
                // Remove null/undefined items
                .filter(error => !!error)
                // Extract an error message
                .map(error => {
                    // UI API read errors
                    if (Array.isArray(error.body)) {
                        return error.body.map(e => e.message);
                    }
                    // UI API DML, Apex and network errors
                    else if (error.body && typeof error.body.message === 'string') {
                        return error.body.message;
                    }
                    // JS errors
                    else if (typeof error.message === 'string') {
                        return error.message;
                    }
                    // Unknown error shape so try HTTP status text
                    return error.statusText;
                })
                // Flatten
                .reduce((prev, curr) => prev.concat(curr), [])
                // Remove empty strings
                .filter(message => !!message)
        );

    }
} 
