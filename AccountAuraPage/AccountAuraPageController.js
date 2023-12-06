({   
    doInit : function(component) {
            var recordId = component.get("v.recordId");
            component.set("v.accountId", recordId);
    },
       
    sendAccountID : function(component) {

        var action = component.get("c.getContactsForAccount");
        action.setParams({ accountId : component.get("v.accountId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find("SampleMessageChannel").publish(response.getReturnValue())
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})