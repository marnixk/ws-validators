namespace eval Validator {

	#
	#	Check whether the this field's content is the same as another field's content
	#   Optionally, one can specify the 'error_msg'
	#
	proc equals {other_name error_msg name input_list} {
		array set input $input_list

		# no fail if not exists
		if {![info exists input($name)] || $input($name) == ""} then {
			return
		}

		set other_value $input($other_name)

		if { $other_value != $input($name) } then {
			if { $error_msg == "" } then {
				return "This field does not equals $other_name"
			} else {
				return $error_msg
			}
		}

		return ""
	}

	#
	#	Make sure the value of this element is one of the values
	#   specified in the `list_of_options`. If not, an error is returned
	#
	proc options {list_of_options name input_list} {
		array set input $input_list

		# no fail if not exists
		if {![info exists input($name)] || $input($name) == ""} then {
			return
		}

		set val $input($name)

		if {[lsearch $list_of_options $val] == -1} then {
			return "Not a valid choice"
		}

		return ""
	}

	#
	#	Make sure this is a date of the yyyy-mm-dd format.
	#
	proc date {name input_list} {
		array set input $input_list

		# no fail if not exists
		if {![info exists input($name)] || $input($name) == ""} then {
			return
		}

		set date_regex {^\d{4}\-\d{2}\-\d{2}$}
		set n_found [regexp $date_regex $input($name)]

		if {$n_found != 1} then {
			return "This is not a valid date"
		}

		return ""
	}

	#
	#	Make sure this is an email address
	#
	proc email {name input_list} {
		array set input $input_list

		# no fail if not exists
		if {![info exists input($name)] || $input($name) == ""} then {
			return
		}

		set email_regex {^[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$}

		set n_found [regexp $email_regex $input($name)]

		if {$n_found != 1} then {
			return "This is not a valid e-mail address"
		}

		return ""
	}

	#
	# 	Determines whether key exists and has a value
	#
	proc required {name input_list} {

		array set input $input_list

		if {![info exists input($name)]} then {
			return "This is a required field"
		}

		if {$input($name) == ""} then {
			return "This is a required field"
		}

		return 

	}

	#
	#  Cannot be longer than `max`
	#
	proc max {max name input_list} {
		array set input $input_list

		# no fail if not exists
		if {![info exists input($name)] || $input($name) == ""} then {
			return
		}

		if {[string length $input($name)] > $max} then {
			return "This field cannot be longer than $max characters"
		}

		return 
	}

	#
	#  Cannot be shorter than `min`
	#
	proc min {min name input_list} {
		array set input $input_list

		# no fail if not exists
		if {![info exists input($name)] || $input($name) == ""} then {
			return
		}

		if {[string length $input($name)] < $min} then {
			return "This field cannot be shorter than $min characters"
		}
		return 
	}


	proc number {name input_list} {
		array set input $input_list

		# no fail if not exists
		if {![info exists input($name)] || $input($name) == ""} then {
			return
		}

		set number_regex {^[0-9]+$}
		set n_found [regexp $number_regex $input($name)]

		if {$n_found != 1} then {
			return "This is not a number"
		}
	}
}