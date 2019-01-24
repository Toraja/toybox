# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.commands.add 'atom-text-editor',
  'custom:cut-to-beginning-of-line', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.selectToFirstCharacterOfLine()   # FIXME <- this throws error in mini editor though running this command from command palette works
    editor.cutSelectedText()

atom.commands.add 'atom-text-editor',
  'custom:cut-whole-line', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.selectLinesContainingCursors()
    editor.cutSelectedText()

atom.commands.add 'atom-text-editor',
  'custom:insert-mark-tag', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText('<mark></mark>')
    editor.moveToBeginningOfWord()
    editor.moveToBeginningOfWord()
    editor.moveLeft(2)

atom.commands.add 'atom-text-editor',
  'custom:insert-span-tag', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText('<span id=""></span>')
    editor.moveToBeginningOfWord()
    editor.moveToBeginningOfWord()
    editor.moveToBeginningOfWord()
    editor.moveRight(2)

atom.commands.add 'atom-text-editor',
  'custom:insert-font-tag', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText('<font color=""></font>')
    editor.moveToBeginningOfWord()
    editor.moveToBeginningOfWord()
    editor.moveToBeginningOfWord()
    editor.moveRight(2)

atom.commands.add 'atom-text-editor',
  'custom:insert-dl-tag', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText('<dl>')
    editor.insertNewline()
    editor.indent()
    editor.insertText('<dt></dt>')
    editor.insertNewline()
    editor.insertText('<dd></dd>')
    editor.insertNewline()
    editor.outdentSelectedRows()
    editor.insertText('</dl>')
    editor.moveUp(2)
    editor.moveRight()

atom.commands.add 'atom-text-editor',
  'custom:markdown-newline', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.moveToEndOfLine()
    editor.insertText('  ')
