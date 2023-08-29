import ballerina/http;
import ballerina/log;

configurable string fromName = "DefaultValue";

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        log:printInfo(fromName);
        if name is "" {
            return error("name should not be empty! " + fromName);
        }
        return fromName + name;
    }
}
