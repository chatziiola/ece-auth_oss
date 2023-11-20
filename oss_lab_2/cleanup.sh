#!/usr/bin/env fish
# Sources:
# https://developerlife.com/2021/01/19/fish-scripting-manual/#:~:text=A%20fish%20function%20is%20just,variables%20in%20fish%20are%20lists).
# https://fishshell.com/docs/current/cmds/argparse.html

##################################################
## TASK
##################################################
# Create the following function
# function cleanup(targetDir, days_inactive, recursive, dry_run, excluded_files_dirs, sort_type, confirmation)
#   * `recursive`, `dry_run`, `confirmation` are of type `boolean`
#   * `targetDir` is a string
#   * `days_inactive` is an integer
#   * `excluded_files`_dirs is a list
#   * `sort_type` is either `asc` or `desc`
#(targetDir days_inactive recursive dry_run excluded_files_dirs sort_type confirmation)

##################################################
## Σημειώσεις για αναγνώστη
##################################################
### Κατανόηση
## Μεταβλητές
# Έχω χρησιμοποιήσει το default library του fish για τα arguments.
# Παίρνει τις μεταβλητές από το $argv, και τις αποθηκεύει στις
# αντίστοιχες μεταβλητές flag που βλέπετε κάτω
## Συναρτήσεις
# Πήρα την πρωτοβουλία να φτιάξω μερικές extra συναρτήσεις, κυρίως για
# διευκόλυνση στην περίπτωση που 1) Βγει κάποιο error (bold_red_echo)
# 2) Κατανόηση του argparse/επιβεβαίωση σωστών τιμών μεταβλητών
# (optionsCheck). Δεν χρειάζεται να απασχολήσουν τον όποιον ελέγξει το
# script καθώς υπο νορμαλ συνθήκες δεν τρέχουν.

##################################################
# ΤΡΕΞΕ ΑΥΤΑ
##################################################
# fish
# cp /home/chatziiol/quiz-2/cleanup.fish . 
# source cleanup.fish #φόρτωση του function
# cleanup <arguments>

# Αυτή η συνάρτηση είναι μόνο για να βγάζω bold στα errors
function bold_red_echo
    echo -e "\e[1;31m$argv\e[0m"
end

# Τυποποιημένη έξοδος των options για κατανόηση της συμπεριφοράς. Μπορεί να χρησιμοποιηθεί με το --debug
function optionsCheck
    echo "########################################"

    if test $(count $_flag_r) = 0
       echo "It is recursive"
    else
	echo "Non-recursive"
    end
       
    if test $(count $_flag_d) = 0
       echo "It will dry run"
    else
	echo "Non-dry_run"
    end

    if test $(count $_flag_c) = 0
       echo "Will ask for confirmation"
    else
	echo "Will not ask for confirmation"
    end
    echo "########################################"
    echo "Script started"
    echo -e "\n\n\n"
end


function cleanup
    # Setting the default values for the rest of the flags
    set -l _flag_i 14 #inactivity by default to 2 weeks
    set -l _flag_s 'asc' #inactivity by default to 2 weeks

    # if test $(count $argv) = 0
    #    set -l _flags_h true
    #  end

    # Negative value for days inactive practically means, edited in the last X days
    argparse	'i/days_inactive=!_validate_int --min -99 --max 99'\
		'e/excluded_file_dirs=+'  \
		's/sort_type='  \
		'c/confirmation'  \
		'r/recursive'  \
		'd/dry_run'  \
		'h/help'  \
		'debug'  \
	     -- $argv

    if test $status -ne 0; or test $(count $_flag_h) -gt 0; or test $(count $argv) -ne 1
	echo ""
	echo "Usage: $fish_script targetDirectory (-i days_inactive) (-e excluded-files) (-s asc/desc) (-r) (-d) (-c)"
	echo "    targetDirectory (non optional)	: The directory to clean up"
	echo "    -i days_inactive			: Number of days of inactivity/ defaults to two weeks"
	echo "    -e excluded_files_dirs		: List of patterns to exclude (e.g., '*.log' '*.tmp')"
	echo "						: Multiple excludes must be preceded by separate -e"
	echo "    -s=sort_type				: Sorting order for files, defaults to asc ('asc' for ascending, 'desc' for descending)"
	echo "    -r / --recursive			: Set to 'true' for recursive cleaning, 'false' otherwise"
	echo "    -d / --dry-run  dry_run		: Set to 'true' to simulate cleanup without actual deletion, 'false' otherwise"
	echo "    -c/--confirmation			: Set to 'true' to prompt for confirmation before deletion, 'false' otherwise"
	echo "    --debug				: Use to run optionsCheck on script's startup"
	echo ""
	echo "Sample usage:"
	echo -e "\t cleanup . -d -r -i 1 -e '*.log' -e '*.txt'"
	return 1
    end

    # Set target directory
    set -l targetDirectory $argv


    if test $(count $_flag_debug) -gt 0
	echo "Target directory is " $targetDirectory
	echo "Inactivity is " $_flag_i
	echo "Excluding " $_flag_e
	echo "Sort Type" $_flag_s
	optionsCheck
	end

    
    if not test -d $targetDirectory
        bold_echo "Error: Target directory does not exist."
        return 1
    end

    # Build the find command
    set find_command "find $targetDirectory -type f -atime +$_flag_i"

    # Add recursive flag if specified
    if test $(count $_flag_r) = 0
        set find_command "$find_command -d 1"
    end

    # Exclude files and directories
    for pattern in $_flag_e
        set find_command "$find_command -not -name '$pattern'"
    end

    # Sort files
    switch $_flag_s
        case "asc"
            set find_command "$find_command | sort"
        case "desc"
            set find_command "$find_command | sort -r"
        case '*'
            bold-echo "Invalid sort type. Please use 'asc' or 'desc'."
            return 1
    end

    # Display files to be deleted in dry-run mode
    if test $(count $_flag_d) -gt 0
	if test $(count $_flag_debug) -gt 0
	    echo -e "Running: \n\t" $find_command
	end
        echo "Files to be deleted: (dry-run)"
        eval $find_command
        return 0
    end

    # Confirm before deletion
    if test $(count $_flag_c) -gt 0
        echo "Are you sure you want to delete the above files? (y/n)"
        read -l response
        if test "$response" != "y"
            echo "Cleanup aborted."
            return 0
        end
    end

    if test $(count $_flag_debug) -gt 0
	echo -e "Running \n\t" $find_command
    end

    # Could be done with exec on find, but then I suppose that the
    # sorting option would be unusable.
    for file in $(eval $find_command )
	rm $file
    end

    echo "Cleanup completed."
end

