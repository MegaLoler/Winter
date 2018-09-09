.include "title.asm"
.include "bgtest.asm"
.include "fgtest.asm"
.include "level.asm"

; engine state handler routines
state_handler_table:
.word title_handler-1
.word bgtest_handler-1
.word fgtest_handler-1
.word level_handler-1
