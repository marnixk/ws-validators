# jsonrpc validator module

This module implements a simple validation mechanism that hooks into the jsonrpc implementation of the websocket-tcl module found among my projects. Whenever a message is sent, it'll check the Action for a "validate" variable. If it is there, it will first go and check to see that the payload is correct. 

If the payload is not correct, an error response is sent.

## Validation format

To add validation to your actions, use the following format:

    namespace eval Action::formsubmit {

        variable validate {
            nickname: required, min 3, max 16
            name: required, min 3
            email: email
            password: required, min 8
            confirmpassword: required, equals "password" "The passwords do not match"
            gender: required, options {male female}
            birthday: required, date
            accept: required, options { true }
        }


        proc on-message {chan message} { 

            app'load-page $chan "nickname"
        }

    }

## Custom validators

To create your own validators, extend the "Validator" namespace and add your functions there. For example, if you wanted to create a "min-value" validator you would write the following code and include it at runtime:

    namespace eval Validator {

        #
        #   Determines whether key exists and if value is smaller than `minvalue`
        #
        proc min-value {minvalue name input_list} {

            array set input $input_list

            if {![info exists input($name)]} then {
                return "$name is not filled out"
            }

            if { $input($name) < $minvalue } then {
                return "$name is smaller than $minvalue"
            }

            return 
        }

You can add as many arguments to your validators as you want.



