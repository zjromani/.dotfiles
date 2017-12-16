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

atom.commands.add 'atom-text-editor.vim-mode-plus.insert-mode',
  'custom:byebug': ->
    atom.workspace.getActiveTextEditor()?.insertText('byebug')

atom.commands.add 'atom-text-editor.vim-mode-plus.insert-mode',
  'custom:todo': ->
    atom.workspace.getActiveTextEditor()?.insertText('# TODO - @johnromani90 - ')

atom.commands.add '.fuzzy-finder atom-text-editor[mini]', 'custom:replace-tab', ->
  atom.workspace.getActiveTextEditor().destroy()
  atom.commands.dispatch(@, "core:confirm")
