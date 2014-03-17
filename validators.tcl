namespace eval Validator {

	#
	# 	Determines whether key exists
	#
	proc required {name input_list} {

		array set input $input_list

		if {![info exists input($name)]} then {
			return "$name is a required field"
		}

		return 

	}

	#
	#  Cannot be longer than `max`
	#
	proc max {max name input} {
		if {[string length $input] > $max} then {
			return "$name cannot be longer than $max characters"
		}
		return 
	}

	#
	#  Cannot be shorter than `min`
	#
	proc min {min name input} {
		if {[string length $input] < $min} then {
			return "$name cannot be shorter than $min characters"
		}
		return 
	}

}