({
    doInit : function(component) {
        var recordId = component.get("v.recordId");
        component.set("v.accountId", recordId);
    },
        
    sendAccountID : function(component){
        let msg = component.get("v.accountId")
        let message={
            lmsData:{
                value:msg
            }
        }
        component.find("SampleMessageChannel").publish(message)
    }
})