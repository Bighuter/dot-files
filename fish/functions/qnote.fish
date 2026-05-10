# ~/.config/fish/functions/qnote.fish

function qnote
    # Define the new, specific directory for all your notes
    set NOTES_DIR $HOME/Sync/Notes/ipynb/Thoughts/journals
    
    # Generate the date-based filename (e.g., 2025_10_15.md)
    set CURRENT_DATE (date +%Y_%m_%d)
    set NOTE_FILE $NOTES_DIR/$CURRENT_DATE.md
    
    # Ensure the notes directory exists
    mkdir -p $NOTES_DIR
    
    # Exit silently if no note text is provided
    if test (count $argv) -eq 0
        return 0
    end
    
    # Get the time stamp using explicit command substitution
    set TIME_STAMP (date +%H:%M)
    
    # Join all arguments ($argv) into a single string
    set NOTE (string join ' ' $argv)
    
    # Append the note text with a time-stamp and a blank line
    echo "- [$TIME_STAMP] $NOTE" >> $NOTE_FILE
    echo "" >> $NOTE_FILE
end
