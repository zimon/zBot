#!/bin/bash
# vim600: set foldmethod=marker: # Faster folding in VIM.

# == General helper functions == {{{1

# version() - Display the version information. {{{2
version() {
    sed -e 's/^    //' <<EndVersion
    TODO.TXT Manager
    Version L1.2
    Author: Gina Trapani (ginatrapani@gmail.com)
    Modified: Lorance Stinson <LoranceStinson+todo@gmail.com>
    Release date: 2006-10-22
    Last updated: 2007-05-21
    License: GPL, http://www.gnu.org/copyleft/gpl.html
    For information on this version see http://lorance.freeshell.org/todo/
    More information on the original and mailing list at http://todotxt.com 
EndVersion
    exit 1
}

# usage() - Display usage help. {{{2
usage() {
    sed -e 's/^    //' <<EndUsage
    Usage: $THIS_SCRIPT  [-cfhHpqvV] [-d config_file] action [item_id]
    Try '$THIS_SCRIPT help' for help on available actions.

    Options:
        -c Force colors on even if STDOUT is not a terminal.
        -d Use a configuration file other than the default ~/.todo.
        -f Forces actions without confirmation or interactive input.
        -h Display this help text.
        -H Keep an activity history in history.txt.
        -p Plain mode turns off colors.
           Colors are disabled automatically if STDOUT is not a terminal.
        -q Quiet mode. Disables verbose mode even if set in the config file.
        -v Verbose mode turns on confirmation messages.
        -V Displays version, license and credits.

    Actions:
        add append archive com comment del do edit editc help history import
        list listall listcontexts listdone listpri listprojects prepend pri
        replace report rm show undo
EndUsage
    exit 1
}

#help() - Display the action help. {{{2
help() {
    sed -e 's/^    //' <<EndHelp
    add "THING I NEED TO DO +project @context"
    a "THING I NEED TO DO +project @context"
        Adds a new item to your todo.txt file.
        Project and context notation optional.
        Quotes optional.

    append ID "TEXT TO APPEND"
    app ID "TEXT TO APPEND"
        Adds text to the end of the item ID.
        Quotes optional.

    archive
        Moves done items from todo.txt to done.txt.

    comment ID ["COMMENT ON TODO"]
    com ID "COMMENT ON TODO"
        Adds a comment to the item ID. View comments with show.  If no text
        is passed the editor defined in \$EDITOR or /usr/bin/vi is started.
        Quotes optional.

    edit ID
    e ID
        Edits the text of the item ID using \$EDITOR or /usr/bin/vi.
        Quotes optional.

    editc ID
    ec ID
        Edits the comment file of the item ID using \$EDITOR or /usr/bin/vi.
        Quotes optional.

    del ID
    rm ID
        Deletes the item ID from todo.txt.

    do ID
        Marks item ID as done in todo.txt.
        Multiple item IDs can be marked as done at once.

    help
        Displays help on available actions.
        
    history [#ID | YYYY-MM-DD | today | LINES]
    h [#ID | YYYY-MM-DD | today | LINES]
        Review the activity history.  With no options displays the entire
        history file.  With # and a item's ID it displays the history for
        that item.  With a date it displays the history for that date, the
        day is optional.  With the word today displays the history for the
        current date.  With just a number it displays that many lines from
        the end of the history file.

    import
        Reads STDIN and adds each line as a new item.  To read a file use input
        redirection, eg "todo.sh import < file.txt".

    list [TERM...]
    ls [TERM...]
        Displays all items that contain TERM(s) sorted by priority.  If no
        TERM specified, lists entire todo.txt.  TERM(s) may be negated by
        prefixing them with a '-'.  Items with comments have a !  added the
        end of the line.

    listall [TERM...]
    lsa [TERM...]
        Displays all the lines in todo.txt AND done.txt that contain TERM(s)
        sorted by priority.  TERM(s) may be negated by prefixing them with a
        '-'.  If no TERM specified, lists entire todo.txt AND done.txt
        concatenated and sorted.

    listcontexts
    lsc
        Displays all the contexts in todo.txt.

    listdone [TERM...]
    lsd [TERM...]
        Displays all the lines in done.txt that contain TERM(s).  TERM(s) may
        be negated by prefixing them with a '-'.  If no TERM is specified,
        lists entire done.txt.

    listpri [PRIORITY]
    lsp [PRIORITY]
        Displays all items prioritized PRIORITY.
        If no PRIORITY specified, lists all prioritized items.

    listprojects
    lspr
        Displays all the projects in todo.txt.

    prepend ID "TEXT TO PREPEND"
    prep ID "TEXT TO PREPEND"
        Adds text to the beginning of the item ID.
        Quotes optional.

    pri ID PRIORITY
    p ID PRIORITY
        Adds PRIORITY to item ID.  If the item is already prioritized,
        replaces current priority with new PRIORITY.  PRIORITY must be an
        uppercase letter between A and Z.  To remove the priority from an
        item do not specify the PRIORITY.

    replace ID "UPDATED TODO"
    r ID "UPDATED TODO"
        Replaces the item ID.

    report
        Adds the number of open items and closed done's to report.txt.
        Completed items are archived first.

    show [ID]
        Displays comments on the item ID.  If no ID is specified diplays each
        item from todo.txt that has comments followed by the comments on that
        item.

    undo ID
        Marks the item ID as not done in todo.txt.
        Multiple todo IDs can be marked not done..
EndHelp

    exit 1
}

# createconfig() - Create the default configuration file. {{{2
createconfig() {
    echo "Could not find configuration files." 1>&2
    echo $NOCR1 "Create default configuration in $HOME/.todo/? (y/n) $NOCR2"
    read ANSWER
    if [ "$ANSWER" = "y" ]; then
        CFG_FILE="$HOME/.todo/todorc"
        mkdir $HOME/.todo/
        [ -d "$HOME/.todo/" ] ||
            die "Fatal Error: Could not create the directory $HOME/.todo/"
        sed -e 's/^        //' <<EndConfig > $HOME/.todo/todorc
        # === EDIT FILE LOCATIONS BELOW ===

        # Your todo.txt directory
        TODO_DIR="\$HOME/.todo"
        #TODO_DIR="C:/Documents and Settings/gina/My Documents"

        # Your todo/done/report.txt locations
        TODO_FILE="\$TODO_DIR/todo.txt"
        DONE_FILE="\$TODO_DIR/done.txt"
        REPORT_FILE="\$TODO_DIR/report.txt"
        TMP_FILE="\$TODO_DIR/todo.tmp"

        # New files by Lorance Stinson.
        ID_FILE="\$TODO_DIR/id.txt"
        HIST_FILE="\$TODO_DIR/history.txt"
        COMMENT_DIR="\$TODO_DIR/comments"

        # == EDIT FILE LOCATIONS ABOVE ===

        # === COLOR MAP ===

        NONE=''
        ESC=\`echo "" | tr "\n" "\033"\`
        BLACK="\$ESC[0;30m"
        RED="\$ESC[0;31m"
        GREEN="\$ESC[0;32m"
        BROWN="\$ESC[0;33m"
        BLUE="\$ESC[0;34m"
        PURPLE="\$ESC[0;35m"
        CYAN="\$ESC[0;36m"
        LIGHT_GREY="\$ESC[0;37m"
        DARK_GREY="\$ESC[1;30m"
        LIGHT_RED="\$ESC[1;31m"
        LIGHT_GREEN="\$ESC[1;32m"
        YELLOW="\$ESC[1;33m"
        LIGHT_BLUE="\$ESC[1;34m"
        LIGHT_PURPLE="\$ESC[1;35m"
        LIGHT_CYAN="\$ESC[1;36m"
        WHITE="\$ESC[1;37m"
        DEFAULT="\$ESC[0m"

        # === PRIORITY COLORS ===

        PRI_A=\$PURPLE   # color for A priority
        PRI_B=\$GREEN    # color for B priority
        PRI_C=\$BLUE     # color for B priority
        PRI_X=\$CYAN     # color for rest of them
        DONE=\$RED       # color for completed todo's

        # === EXTRA OPTIONS ===

        # I like todo.sh to always be verbose.
        # This just overrides the default in todo.sh.
        VERBOSE=1

        # Keep a history of all changes.
        # If this is set to a true value a history of all activities that alters the
        # todo.txt file is kept in the file specified by HIST_FILE above.
        # To disable the history function simply comment out this line.
        # This option can also be set manually via the -H command line option.
        HISTORY=1
EndConfig
        [ -r "$CFG_FILE" ] ||
            die "Fatal Error: Could not create configuration file $CFG_FILE."
    fi
}

# die() - Print an error message and exit. {{{2
die() {
    echo "$*" 1>&2
    exit 1
}

# encode_id() - Convert a base 10 number into a base 32 code. {{{2
# This and decode_id work like Number::RecordLocator used by hiveminder.com.
# Since 0,1,S and B tend be be confused for O, I, F and P respectively by look
# or sound the former is transformed into the latter. This is neatest part of
# the module.
encode_id() {
    echo "$1" | awk '{id="";while($1>0){id=substr("23456789ACDEFGHIJKLMNOPQRTUVWXYZ",($1%32)+1,1)id;$1=int($1/32)}print id}'
}

# decode_id() - Convert a base 32 code into a base 10 number. {{{2
decode_id() {
    echo $1 | tr 'a-z' 'A-Z' | tr '01SB' 'OIFP' | \
    awk '{num=0;for(i=1;i<length($1)+1;i++){num=(num*32)+index("23456789ACDEFGHIJKLMNOPQRTUVWXYZ",substr($1,i,1))-1}print num}'
}

# Add a line to the history file.
add_hist() {
    action="$1"
    item="$2"
    input="$3"
    echo "`date '+%Y-%m-%d %T'` $action: $item: $input" >> $HIST_FILE
}

# print_todos() - Print the records in the specified file. {{{2
# The file is read by the while loop.
# If a todo has a comment file a ! is appended to the line.
# The first sed command adds priority _ to todo's that have no priority.
# The _ priority allows sorting to work properly.
# The sort command sorts by the priority then by the todo ID.
# The awk command adds color to priorities.
# The next sed commands add coloring to completed items.
# The final sed command removes the dummy _ priority.
print_todos() {
    while read input ; do
        item=`expr "$input" : '\([0-9A-Z]*\):'`
        if [ -f "$COMMENT_DIR/$item" ] ; then
            echo "$input !"
        else
            echo "$input"
        fi
    done |
    sed -e '/[0-9A-Z]*: ([A-Z]) /!s/^\([0-9A-Z]*:\) */\1 (_) /' | \
    sort -f +1 -2 | \
    awk '/^[0-9A-Z]*: \([A-Z]\)/ {
            match($0,/^[0-9A-Z]*: \([A-Z]/);
            color=ENVIRON["PRI_" substr($0,RLENGTH,1)];
            if (color)
                print color $0 ENVIRON["DEFAULT"]
            else
                print ENVIRON["PRI_X"] $0 ENVIRON["DEFAULT"] }
        !/^[0-9A-Z]*: \([A-Z]\)/ {print $0}' | \
    sed 's/^\([0-9A-Z]*:\) (_)\( x.*\)/'$DONE'\1\2'$DEFAULT'/' | \
    sed -e 's/^\([0-9A-Z]*: \)(_) /\1/'
}

# == Item manipulation functions == {{{1

# add_todo() - Add a new todo. {{{2
add_todo() {
    errmsg="usage: $THIS_SCRIPT add \"TODO ITEM\""
    if [ -z "$2" -a "$FORCE" -eq 0 ]; then
        echo $NOCR1 "Add: $NOCR2"
        read input
    else
        [ -z "$2" ] && die $errmsg
        shift
        input=$*
    fi

    # Get the next number.
    ITEMID=`cat $ID_FILE`
    echo `expr $ITEMID + 1` > $ID_FILE
    ITEMID=`encode_id $ITEMID`

    # Add the item.
    echo "$ITEMID: $input" >> "$TODO_FILE"

    [ $VERBOSE -eq 1 ] && echo "$SCRIPT_BASE: '$input' added as '$ITEMID'."
    [ $HISTORY -eq 1 ] && add_hist "add" "$ITEMID" "$input"
}

# append_todo() - Append text to a todo. {{{2
append_todo() {
    errmsg="usage: $THIS_SCRIPT append ITEM# \"TEXT TO APPEND\""
    shift; item=`echo "$1" | tr 'a-z' 'A-Z'`; shift
    [ -z "$item" ] && die "$errmsg"

    if grep "^$item:" "$TODO_FILE" ; then
        if [ -z "$1" -a "$FORCE" -eq 0 ]; then
            echo $NOCR1 "Append: $NOCR2"
            read input
        else
            input=$*
        fi

        cp "$TODO_FILE" "$TODO_FILE.bak"
        if sed "s|^$item:.*|& $input|" "$TODO_FILE.bak" > "$TODO_FILE" ; then
            [ $VERBOSE -eq 1 ] && grep "^$item:" "$TODO_FILE"
        else
            echo "$SCRIPT_BASE: Error appending item '$item'." 1>&2
        fi
    else
        echo "$SCRIPT_BASE: No such item '$item'." 1>&2
    fi
    [ $HISTORY -eq 1 ] && add_hist "append" "$item" "$input"
}

# archive_todo() - Move completed todos to done.txt. {{{2
archive_todo() {
    [ $VERBOSE -eq 1 ] && grep "^[0-9A-Z]*: x " "$TODO_FILE"
    grep "^[0-9A-Z]*: x " "$TODO_FILE" >> "$DONE_FILE"
    cp "$TODO_FILE" "$TODO_FILE.bak"
    sed '/^[0-9A-Z]*: x /d' "$TODO_FILE.bak" > "$TODO_FILE"
    [ $VERBOSE -eq 1 ] && echo "--"
    [ $VERBOSE -eq 1 ] && echo "$SCRIPT_BASE: Items marked as done have been moved from `basename $TODO_FILE` to `basename $DONE_FILE`."
    [ $HISTORY -eq 1 ] && add_hist "archive" "none"
}

# comment_todo() - Add a new comment to a todo. {{{2
comment_todo() {
    errmsg="usage: $THIS_SCRIPT comment ITEM# \"COMMENT TO ADD\""
    shift; item=`echo "$1" | tr 'a-z' 'A-Z'`; shift
    [ -z "$item" ] && die "$errmsg"

    if grep "^$item:" "$TODO_FILE" ; then
        if [ -z "$1" -a "$FORCE" -eq 0 ]; then
            editor="${EDITOR:=/usr/bin/vi}"
            $editor $TMP_FILE
            input=`cat $TMP_FILE`
        else
            input=$*
        fi
        CDATE=`date +"%Y-%m-%d %T"`
        (echo ""; echo "$CDATE"; echo "$input") >> $COMMENT_DIR/$item
    else
        echo "$SCRIPT_BASE: No such item '$item'." 1>&2
    fi
}

# delete_todo() - Delete a todo. {{{2
delete_todo() {
    errmsg="usage: $THIS_SCRIPT del ITEM#"
    item=`echo "$2" | tr 'a-z' 'A-Z'`
    [ -z "$item" ] && die "$errmsg"

    DELETEME=`grep "^$item:" "$TODO_FILE"`
    if [ "$DELETEME" ]; then

        if  [ "$FORCE" -eq 0 ]; then
            echo $NOCR1 "Delete '$DELETEME'?  (y/n) $NOCR2"
            read ANSWER
        else
            ANSWER="y"
        fi

        if [ "$ANSWER" = "y" ]; then
            cp "$TODO_FILE" "$TODO_FILE.bak"
            sed -e "/^$item: /d" "$TODO_FILE.bak" > "$TODO_FILE"
            [ -f $COMMENT_DIR/$item ] && rm -f $COMMENT_DIR/$item 2> /dev/null
            [ $VERBOSE -eq 1 ] && echo "$SCRIPT_BASE: '$DELETEME' deleted."
            [ $HISTORY -eq 1 ] && add_hist "del" "$item"
        else
            echo "$SCRIPT_BASE: No items were deleted." 1>&2
        fi
    else
        echo "$SCRIPT_BASE: No such item '$item'." 1>&2
    fi
}

# do_todo() - Mark a todo as done. {{{2
do_todo() {
    errmsg="usage: $THIS_SCRIPT do ITEM#"
    shift
    while [ "$#" -gt 0 ] ; do
        item=`echo "$1" | tr 'a-z' 'A-Z'`
        [ -z "$item" ] && die "$errmsg"

        if grep "^$item:" "$TODO_FILE" ; then
            now=`date '+%Y-%m-%d'`
            # remove priority once item is done
            cp "$TODO_FILE" "$TODO_FILE.bak"
            sed -e "s/^$item: \(([A-Z])\)* */$item: x $now /" "$TODO_FILE.bak" > "$TODO_FILE"
            [ $VERBOSE -eq 1 ] && grep "^$item:" "$TODO_FILE"
            [ $VERBOSE -eq 1 ] && echo "$SCRIPT_BASE: Marked item '$item' as done."
            [ $HISTORY -eq 1 ] && add_hist "do" "$item"
        else
            echo "$SCRIPT_BASE: No such item '$item'." 1>&2
        fi
    shift
    done
}

# edit_comment() - Edit the comment file for a todo. {{{2
edit_comment() {
    errmsg="usage: $THIS_SCRIPT editc ITEM#"
    item=`echo "$2" | tr 'a-z' 'A-Z'`
    [ -z "$item" ] && die "$errmsg"
    if [ -f $COMMENT_DIR/$item ] ; then
        sed '1{/^$/d;}' $COMMENT_DIR/$item > $TMP_FILE
        editor="${EDITOR:=/usr/bin/vi}"
        $editor $TMP_FILE
        (echo ""; cat $TMP_FILE) > $COMMENT_DIR/$item
        rm -f $TMP_FILE 2>/dev/null
    else
        echo "$item: No comments have been made on that todo." 1>&2
    fi
}

# edit_todo() - Edit the text for a todo. {{{2
edit_todo() {
    errmsg="usage: $THIS_SCRIPT edit ITEM#"
    item=`echo "$2" | tr 'a-z' 'A-Z'`
    [ -z "$item" ] && die "$errmsg"

    if grep "^$item:" "$TODO_FILE" ; then
        TMP_FILE="${TMP_FILE}_$item"
        grep "^$item:" "$TODO_FILE" | sed -e "s/^$item: *//" > $TMP_FILE
        editor="${EDITOR:=/usr/bin/vi}"
        $editor $TMP_FILE
        input=`cat $TMP_FILE | tr '\n\r' ' ' | sed -e 's/ *$//'`
        rm -f $TMP_FILE 2>/dev/null
        cp "$TODO_FILE" "$TODO_FILE.bak"
        sed "s|^$item: .*|$item: $input|" "$TODO_FILE.bak" > "$TODO_FILE"
        [ $VERBOSE -eq 1 ] && grep "^$item:" "$TODO_FILE"
        [ $HISTORY -eq 1 ] && add_hist "edit" "$item" "$input"
    else
        echo "$SCRIPT_BASE: No such item '$item'." 1>&2
    fi
}

# history_todo() - Display the history. {{{2
history_todo() {
    item="$2"
    if [ -z "$item" ] ; then
        # The whole file.
        cat $HIST_FILE
    elif [ `echo "$2" | tr 'a-z' 'A-Z'` = "TODAY" ] ; then
        # Just entries for today.
        grep `date +"%Y-%m-%d"` $HIST_FILE
    elif [ `expr "$item" : '[0-9][0-9]*-[0-9][0-9]*'` -gt 0 ] ; then
        # A specific date.
        grep "^$item" $HIST_FILE
    elif [ `expr "$item" : '[0-9]*$'` -gt 0 ] ; then
        # The last N lines.
        tail -n $item $HIST_FILE
    else
        # A specific todo.
        item=`echo "$item" | sed -e 's/^#//' | tr 'a-z' 'A-Z'`
        grep "^[-:0-9 ]* [a-z]*: $item: " $HIST_FILE
    fi
}

# import_todo() - Import items from STDIN. {{{2
import_todo() {
    while read input ; do
        add_todo "add" "$input"
    done
}

# list_todo() - List the items in todo.txt. {{{2
list_todo() {
    item=$2
    if [ -z "$item" ]; then
        print_todos < "$TODO_FILE"
        echo "--"
        NUMITEMS=`wc -l "$TODO_FILE" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/'`
        echo "$SCRIPT_BASE: $NUMITEMS items in `basename $TODO_FILE`."
    else
        list=`print_todos < "$TODO_FILE"`
        shift
        for i in $* ; do
            if [ `expr "$i" : '-.*'` -gt 0 ] ; then
                i="-v `expr "$i" : '-\(.*\)'`"
            fi
            list=`echo "$list" | grep -i $i `
        done
        echo "$list"
    fi
}

# listall_todo() - List all items from todo.txt and done.txt. {{{2
listall_todo() {
    item=$2
    cat "$TODO_FILE" "$DONE_FILE" > "$TMP_FILE"

    if [ -z "$item" ]; then
        print_todos < "$TMP_FILE"
        echo "--"
        NUMITEMS=`wc -l "$TMP_FILE" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/'`
        echo "$SCRIPT_BASE: $NUMITEMS total items."
    else
        command=`print_todos < "$TMP_FILE"`
        shift
        for i in $* ; do
            if [ `expr "$i" : '-.*'` -gt 0 ] ; then
                i="-v `expr "$i" : '-\(.*\)'`"
            fi
            command=`echo "$command" | grep -i $i `
        done
        echo "$command"
    fi
}

# listdone_todo() - List items marked as done. {{{2
listdone_todo() {
    item=$2
    if [ -z "$item" ]; then
        print_todos < "$DONE_FILE"
        echo "--"
        NUMITEMS=`wc -l "$DONE_FILE" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/'`
        echo "$SCRIPT_BASE: $NUMITEMS items in `basename $DONE_FILE`."
    else
        command=`print_todos < "$DONE_FILE"`
        shift
        for i in $* ; do
            if [ `expr "$i" : '-.*'` -gt 0 ] ; then
                i="-v `expr "$i" : '-\(.*\)'`"
            fi
            command=`echo "$command" | grep -i $i `
        done
        echo "$command"
    fi
}

# listpri_todo() - List prioritized items. {{{2
listpri_todo() {
    pri=`printf "%s\n" "$2" | tr 'a-z' 'A-Z'`
    errmsg="usage: $THIS_SCRIPT listpri PRIORITY
note: PRIORITY must a single letter from A to Z."

    if [ -z "$pri" ]; then
        print_todos < "$TODO_FILE" | grep \([A-Z]\)
        if [ $VERBOSE -eq 1 ]; then
            echo "--"
            NUMITEMS=`grep \([A-Z]\) "$TODO_FILE" | wc -l | sed 's/^[[:space:]]*\([0-9]*\).*/\1/'`
            echo "$SCRIPT_BASE: $NUMITEMS prioritized items in `basename $TODO_FILE`."
        fi
    else
        [ `expr "$pri" : '[A-Z]'` -gt 0 ] || die "$errmsg"
        print_todos < "$TODO_FILE" | grep \($pri\)
        if [ $VERBOSE -eq 1 ]; then
            echo "--"
            NUMITEMS=`grep \($pri\) "$TODO_FILE" | wc -l | sed 's/^[[:space:]]*\([0-9]*\).*/\1/'`
            echo "$SCRIPT_BASE: $NUMITEMS items prioritized $pri in `basename $TODO_FILE`."
        fi

    fi
}

# prepend_todo() - Prepend text into an item. {{{2
prepend_todo() {
    errmsg="usage: $THIS_SCRIPT prepend ITEM# \"TEXT TO PREPEND\""
    shift; item=`echo "$1" | tr 'a-z' 'A-Z'`; shift
    [ -z "$item" ] && die "$errmsg"

    if grep "^$item:" "$TODO_FILE" ; then
        if [ -z "$1" -a "$FORCE" -eq 0 ]; then
            echo $NOCR1 "Prepend: $NOCR2"
            read input
        else
            input=$*
        fi

        cp "$TODO_FILE" "$TODO_FILE.bak"
        if sed "s|^$item:\( ([A-Z])\)* \(.*\)|$item:\1 $input \2|" "$TODO_FILE.bak" > "$TODO_FILE" ; then
            [ $VERBOSE -eq 1 ]  && grep "^$item:" "$TODO_FILE"
            [ $HISTORY -eq 1 ] && add_hist "prepend" "$item" "$input"
        else
            echo "$SCRIPT_BASE: Error prepending item '$item'." 1>&2
        fi
    else
        echo "$SCRIPT_BASE: No such item '$item'." 1>&2
    fi
}

# pri_todo() - Change the priority on an item. {{{2
pri_todo() {
    item=`echo "$2" | tr 'a-z' 'A-Z'`
    newpri=`printf "%s\n" "$3" | tr 'a-z' 'A-Z'`

    errmsg="usage: $THIS_SCRIPT pri ITEM# PRIORITY
note: PRIORITY must a single letter from A to Z."

    [ "$#" -lt 2 ] && die "$errmsg"

    sed -e "s/^\($item: \)(.*) /\1/" -e "s/^$item: /$item: ($newpri) /" "$TODO_FILE" > /dev/null 2>&1
    if [ "$?" -eq 0 ]; then
        #it's all good, continue
        cp "$TODO_FILE" "$TODO_FILE.bak"
        if [ `expr "$newpri" : '[A-Z]'` -gt 0 ] ; then
            sed -e "s/^\($item: \)(.*) /\1/" -e "s/^\($item: \)/$item: ($newpri) /" "$TODO_FILE.bak" > "$TODO_FILE"
        else
            sed -e "s/^\($item: \)(.*) /\1/" "$TODO_FILE.bak" > "$TODO_FILE"
        fi
        [ -z "$newpri" ] && newpri="None"
        [ $VERBOSE -eq 1 ] && grep "^$item:" "$TODO_FILE"
        [ $VERBOSE -eq 1 ] && echo "$SCRIPT_BASE: Changed priority on item '$item' to ($newpri)."
        [ $HISTORY -eq 1 ] && add_hist "pri" "$item" "$newpri"
        else
        die "$errmsg"
    fi
}

# replace_todo() - Replace the text for an item. {{{2
replace_todo() {
    errmsg="usage: $THIS_SCRIPT replace ITEM# \"UPDATED ITEM\""
    shift; item=`echo "$1" | tr 'a-z' 'A-Z'`; shift
    [ -z "$item" ] && die "$errmsg"

    if grep "^$item:" "$TODO_FILE" ; then
        if [ -z "$1" -a "$FORCE" -eq 0 ]; then
            echo $NOCR1 "Replacement: $NOCR2"
            read input
        else
            input=$*
        fi

        cp "$TODO_FILE" "$TODO_FILE.bak"
        sed "s|^$item: .*|$item: $input|" "$TODO_FILE.bak" > "$TODO_FILE"
        [ $VERBOSE -eq 1 ] && echo "replaced with"
        [ $VERBOSE -eq 1 ] && grep "^$item:" "$TODO_FILE"
        [ "$HISTORY" ] && add_hist "replace" "$item" "$input"
    else
        echo "$SCRIPT_BASE: No such item '$item'."
    fi
}

# report_todo() - Generate a report. {{{2
report_todo() {
    # Archive first
    grep "^[0-9A-Z]*: x " "$TODO_FILE" >> "$DONE_FILE"
    cp "$TODO_FILE" "$TODO_FILE.bak"
    sed -e '/^[0-9A-Z]*: x /d' "$TODO_FILE.bak" > "$TODO_FILE"

    NUMLINES=`wc -l "$TODO_FILE" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/'`
    if [ "$NUMLINES" = "0" ]; then
         echo "datetime todos dones" >> "$REPORT_FILE"
    fi

    # Now report
    TOTAL=`cat "$TODO_FILE" | wc -l | sed 's/^[ \t]*//'`
    TDONE=`cat "$DONE_FILE" | wc -l | sed 's/^[ \t]*//'`
    TDATE=`date +"%Y-%m-%d %T"`
    TECHO=`echo $TDATE; echo ' '; echo $TOTAL; echo ' '; echo $TDONE`
    echo $TECHO >> "$REPORT_FILE"
    [ $VERBOSE -eq 1 ] && echo "$SCRIPT_BASE: Report file updated."
    cat "$REPORT_FILE"
    [ "$HISTORY" ] && add_hist "report" "none"
}

# show_todo() - Show the comments made on an item. {{{2
show_todo() {
    item=`echo "$2" | tr 'a-z' 'A-Z'`

    if [ -z "$item" ] ; then
        for COMMENT in `ls "$COMMENT_DIR" 2>/dev/null | sort` ; do
            if grep "^$COMMENT: " $TODO_FILE ; then
                cat $COMMENT_DIR/$COMMENT
                echo ""
            fi
        done

    else
        if [ -f $COMMENT_DIR/$item ] ; then
            grep "^$item: " $TODO_FILE || grep "^$item: " $DONE_FILE
            cat $COMMENT_DIR/$item
        else
            echo "$item: No comments have been made on that todo."
        fi
    fi
}

# undo_todo() - Mark an item as not done. {{{2
undo_todo() {
    errmsg="usage: $THIS_SCRIPT undo ITEM#"
    shift
    while [ "$#" -gt 0 ] ; do
        item=`echo "$1" | tr 'a-z' 'A-Z'`
        [ -z "$item" ] && die "$errmsg"

        if grep "^$item:" "$TODO_FILE" ; then
            cp "$TODO_FILE" "$TODO_FILE.bak"
            sed -e "s/^$item: x [0-9]*-[0-9]*-[0-9]*/$item:/" "$TODO_FILE.bak" > "$TODO_FILE"
            [ $VERBOSE -eq 1 ] && grep "^$item:" "$TODO_FILE"
            [ $VERBOSE -eq 1 ] && echo "$SCRIPT_BASE: Marked item '$item' as not done."
            [ $HISTORY -eq 1 ] && add_hist "undo" "$item"
        else
            echo "$SCRIPT_BASE: No such item '$item'."
        fi
    shift
    done
}

# == Process options == {{{1
# Adapt to different names for the script.
THIS_SCRIPT=`basename $0`
SCRIPT_BASE=`echo $THIS_SCRIPT | sed -e 's/^\([^\.]*\)\..*/\1/'`

# defaults
VERBOSE=0
PLAIN=0
CFG_FILE=$HOME/.$SCRIPT_BASE
FORCE=0
HISTORY=0
QUIET=0

# To adapt to System V vs. BSD 'echo'
if echo '\c' | grep -s c > /dev/null ; then
    # BSD
    NOCR1='-n'
    NOCR2=""
else
    # System V
    NOCR1=""
    NOCR2='\c'
fi

# If $HOME/.todo is a directory check it for todorc as the config file.
# If that does not exist check for ~/.todorc
if [ -d "$CFG_FILE" -a -f "$CFG_FILE/${SCRIPT_BASE}rc" ] ; then
    CFG_FILE="$CFG_FILE/${SCRIPT_BASE}rc"
elif [ ! -r "$CFG_FILE" -a -r "$HOME/.${SCRIPT_BASE}rc" ] ; then
    CFG_FILE="$HOME/.${SCRIPT_BASE}rc"
fi

# Disable colors if STDOUT is not a terminal.
[ -t 1 ] || PLAIN=1

while getopts ":fhHpqcvVd:" OPTION ; do
    case $OPTION in
        c) PLAIN=0 ;;
        d) CFG_FILE=$OPTARG ;;
        f) FORCE=1 ;;
        h) usage ;;
        H) HISTORY=1 ;;
        p) PLAIN=1 ;;
        q) QUIET=1 ;;
        v) VERBOSE=1 ;;
        V) version ;;
    esac
done
shift `expr $OPTIND - 1`

# If the configuration file can not be found attempt to create it.
[ -f "$CFG_FILE" ] || createconfig

# === SANITY CHECKS (thanks Karl!) === {{{1
[ -r "$CFG_FILE" ] || die "Fatal error: Cannot read configuration file $CFG_FILE"

. "$CFG_FILE" > /dev/null 2>&1 || die "Fatal error: Could not read the configuration file $CFG_FILE."

[ -z "$1" ]             && usage
[ $QUIET -eq 1 ]        && VERBOSE=0
[ -d "$TODO_DIR" ]      || die "Fatal Error: $TODO_DIR is not a directory"
cd "$TODO_DIR"          || die "Fatal Error: Unable to cd to $TODO_DIR"

echo '' > "$TMP_FILE"   || die "Fatal Error: Unable to write in $TODO_DIR"
[ -f "$TODO_FILE" ]     || cp /dev/null "$TODO_FILE"
[ -f "$DONE_FILE" ]     || cp /dev/null "$DONE_FILE"
[ -f "$REPORT_FILE" ]   || cp /dev/null "$REPORT_FILE"
[ -z "$HIST_FILE" ]     && HIST_FILE="$TODO_DIR/history.txt"
[ -f "$HIST_FILE" ]     || cp /dev/null "$HIST_FILE"
# 264 results in a starting number of AA and 8456 in AAA.
# See decode_id if you want to start at a specific ID.
[ -z "$ID_FILE" ]       && ID_FILE="$TODO_DIR/id.txt"
[ -f "$ID_FILE" ]       || echo "264"> "$ID_FILE"
[ -z "$COMMENT_DIR" ]   && COMMENT_DIR="$TODO_DIR/comments"
[ -d "$COMMENT_DIR" ]   || mkdir $COMMENT_DIR

# Grab the priority colors for use in the next two steps.
PRI_COLORS=`grep ^PRI $CFG_FILE | sed 's/=.*$//'`

# Clear the colors if plain text is to be used.
if [ $PLAIN -eq 1 ]; then
    DONE=$NONE
    DEFAULT=$NONE
    for color in $PRI_COLORS ; do
        eval "$color=$NONE"
    done
fi

# Export the colors so the print function can find them.
export DEFAULT DONE $PRI_COLORS

# Make sure the temp file is removed.
trap "[ -f \"$TMP_FILE\" ] && rm \"$TMP_FILE\"" 0 1 2 3 15

# == Handle the action == {{{1
action=`printf "%s\n" "$1" | tr 'A-Z' 'a-z'`
case $action in
    add|a|ad*)          add_todo "$@" ;;
    append|ap*)         append_todo "$@" ;;
    archive|ar*)        archive_todo ;;
    comment|c*)         comment_todo "$@" ;;
    del|rm)             delete_todo "$@" ;;
    do)                 do_todo "$@" ;;
    editc|ec*)          edit_comment "$@" ;;
    edit|e*)            edit_todo "$@" ;;
    history|h|hi*)      history_todo "$@" ;;
    import)             import_todo ;;
    help)               help ;;
    list|ls|l)          list_todo "$@" ;;
    listall|lsa|la)     listall_todo "$@" ;;
    listcontexts|lsc|lc)
        tr " " "\n" < "$TODO_FILE" | grep "^@" | sort | uniq ;;
    listprojects|lspr|lpr)
        tr " " "\n" < "$TODO_FILE" | egrep "^\+|^p:" | sort | uniq ;;
    listdone|lsd|ld)    listdone_todo "$@" ;;
    listpri|lsp|lp)     listpri_todo "$@" ;;
    prepend|pre*)       prepend_todo "$@" ;;
    pri|p)              pri_todo "$@" ;;
    replace|r|repl*)    replace_todo "$@" ;;
    report|repo*)       report_todo ;;
    show)               show_todo "$@" ;;
    undo)               undo_todo "$@" ;;
    *)                  usage ;;
esac
