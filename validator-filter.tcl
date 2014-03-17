#
#	
#
namespace eval Validator {

	jsonrpc'has-on-message-callback

	#
	#	Take a list of things to be validated (`what`) and 
	#	the content it needs to validate on 
	#
	proc validate-information {what info_list} {
		array set info $info_list

		set instr_list [split $what "\n"]

		lappend errors

		# iterate over each validation instruction
		foreach instr $instr_list {
			validate-rule errors $instr $info_list
		}

		return $errors
	}

	#
	#	Parse a validation rule and run it to see
	#	if it causes any errors
	#
	proc validate-rule {r_errors instr info_list} {
		upvar 1 $r_errors errors

		# get validation information
		lassign [parse-validation-pair $instr] name validators

		if {[llength $validators] == 0} then {
			return
		}

		# iterate over each validator and store any errors
		foreach validator $validators {
			set error [check-for-error $validator $name $info_list]
			if {$error != ""} then {
				lappend errors $error
			}
		}
	}

	#
	# 	Extract information about the validation rule
	#	detailed in $instr. Format would be:
	#
	#		name: validatorname [arguments], ..
	#
	proc parse-validation-pair {instr} {
		set instr [string trim $instr]
		if {$instr == ""} then {
			return
		}

		# find the name, and the validators associated to it
		lassign [split $instr ":"] name validators

		set validators [split $validators ","]

		return [list $name $validators]
	}

	#
	#	Check to see if there is an error 
	#
	proc check-for-error {validator name info_list} {
		set validator [string trim $validator]
		return [{*}$validator $name $info_list]
	}

	#
	#	Send a validation response to the user
	#
	proc send-response {chan input errorlist} {

		array set response [jsonrpc'respond-to $input]

		set response(state) [j' "error"]
		set response(errors) [j'list $errorlist]

		parray response

		Websocket::send-message $chan [json::encode [json::array response]]
	}

	#
	#	When a message arrives, try and see if we should validate it by checking if the 'validate' 
	#	variable on it is set.
	#
	proc on-message {chan message} {
		# get tcl structure for json message
		set input [json::json2dict $message]
		set payload [dict get $input payload]

		# can't validate something that doesn't exist
		if { ![dict exists $input action] } then {
			return
		} else {
			set action [dict get $input action]
			set validator_location [subst -nocommands "Action::${action}::validate"]

			if {[info exists $validator_location]} then {
				set body [subst -nocommands "\${$validator_location}"]
				set errors [validate-information $body $payload]

				if {[llength $errors] > 0} then {
					send-response $chan [dict get $input] $errors
					return "stop-processing"
				}
			}

		}

	}

}

