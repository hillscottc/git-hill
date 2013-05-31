Title: emacs keys
Date: 2013-05-29
Category: Keyboard
Tags: emacs, bash
Slug: emacs-keys
Author: Scott Hill
Summary: Keyboard shortcuts for emacs.


# emacs keys

C = Control, M = Meta = Alt|Esc  

### Basics
    C-x C-f "find" file i.e. open/create a file in buffer
    C-x C-s save the file
    C-x C-w write the text to an alternate name
    C-x C-v find alternate file
    C-x i insert file at cursor position
    C-x b create/switch buffers
    C-x C-b show buffer list
    C-x k kill buffer
    C-z suspend emacs 
    C-X C-c close down emacs


### Basic movement
    C-f forward char
    C-b backward char
    C-p previous line
    C-n next line
    M-f forward one word
    M-b backward one word
    C-a beginning of line
    C-e end of line
    C-v one page up
    M-v scroll down one page
    M-< beginning of text
    M-> end of text
    C-x C-x exchange cursor and mark (Toggle start and end?)

### Programming
    M-a beginning of statement
    M-e end of statement
    M C-a beginning of function
    M C-e end of function
    C-c C-c comment out marked area
    M-x outline-minor-mode collapses function defs
    M-x show-subtree Expand collapsed functions defs
    M-. (Thats Meta dot) Go to current functions's definition 

### Editing
    M-n repeat the following command n times
    C-u repeat the following command 4 times
    C-u n repeat n times
    C-d delete a char
    M-d delete word
    M-Del delete word backwards
    C-k kill line forward
    C-u kill line back
    C-x C-t transpose lines

### Mark, Yank, and Paste
    C-Space Set beginning mark 
    C-W "kill" (delete) the marked region region
    M-W copy the marked region
    C-y "yank" (paste) the copied/killed region/line
    M-y yank earlier text (cycle through kill buffer)


### Undo
    C-g quit the running/entered command
    C-x u undo previous action
    M-x revert-buffer RETURN (type just like that)  
        undo all changes since last save
    M-x recover-file RETURN  
        Recover text from an autosave-file
    M-x recover-session RETURN 
        if you edited several files
    C-_ C-x C-u Undo the last editing command
    M-r Undo all changes made to this line



### Search/Replace
    C-s Search forward
    C-r search backward
    C-g return to where search started (if in srch mode)
    M-% query replace
    Space or y replace this occurence
    Del or n don't replace
    . only replace this and exit (replace)
    , replace and pause (resume with Space or y)
    ! replace all following occurences
    ^ back to previous match  
    RETURN or q quit replace


### Search/Replace with regular expressions
    Characters to use in regular expressions:
    ^ beginning of line
    $ end of line
    . single char
    .* group or null of chars
    \< beginning of a word
    \> end of a word
    [] every char inside the backets

    M C-s RETURN search for regular expression forward
    M C-r RETURN search for regular expression backward
    M C-s incremental search
    C-s repeat incremental search
    M C-r incremental search backwards
    C-r repeat backwards
    M-x query-replace-regexp search and replace

### Window-Commands
    C-x 2 split window vertically
    C-x o change to other window
    C-x 0 delete window
    C-x 1 close all windows except the one the cursors in
    C-x ^ enlarge window
    M-x shrink-window command says it ;-)
    M C-v scroll other window
    C-x 4 f find file in other window
    C-x 4 o change to other window
    C-x 4 0 kill buffer and window
    C-x 5 2 make new frame
    C-x 5 f find file in other frame
    C-x 5 o change to other frame
    C-x 5 0 close this frame

### Bookmark commands
    C-x r m set a bookmark at current cursor pos
    C-x r b jump to bookmark
    M-x bookmark-rename says it
    M-x bookmark-delete "
    M-x bookmark-save "
    C-x r l list bookmarks
        d mark bookmark for deletion
        r rename bookmark
        s save all listed bookmarks
        f show bookmark the cursor is over
        m mark bookmarks to be shown in multiple window
        v show marked bookmarks (or the one the cursor is over)
        t toggle listing of the corresponding paths
        w " path to this file
        x delete marked bookmarks
        Del ?
        q quit bookmark list
    M-x bookmark-write write all bookmarks in given file
    M-x bookmark-load load bookmark from given file

### Version Control
    C-x v d show all registered files in this dir
    C-x v = show diff between versions
    C-x v u remove all changes since last checkin


### Auto-Complete
    TAB    Auto-complete a name
    M-/  Auto-complete a name (without smart completion) 
    M-?  List the possible completions of the preceeding text
    M-*  Insert all possible completions of the preceeding text






