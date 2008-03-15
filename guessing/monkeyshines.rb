require 'locknote'

# START:monkey
note = Note.open
100.times {note.random_action}
# END:monkey
