#!/usr/bin/env coffee

exec = require('child_process').exec

write = (text) ->
  process.stdout.write "#{text}\n"

warn = (text) ->
  process.stderr.write "#{text}\n"

showVersion = ->
  write 'swbox 0.0.1'
  write '© Zarino Zappia, AGPL Licensed'

showHelp = ->
    write 'swbox:\tA command line interface for interacting with ScraperWiki boxes'
    write 'Usage:\tswbox <command> [args]'
    write 'Commands:'
    write '\tswbox mount <boxName>\tMount <boxName> as an sshfs drive'
    write '\tswbox unmount <boxName>\tUnmount the <boxName> sshfs drive'
    write '\tswbox [-v|--version]\tShow version & license info'
    write '\tswbox help\t\tShow this documentation'

mountBox = ->
  args = process.argv[3..]
  if args.length == 1
    boxName = args[0]
    path = "/tmp/ssh/#{boxName}"
    exec "mkdir -p #{path} && sshfs #{boxName}@box.scraperwiki.com:. #{path} -ovolname=#{boxName}", (err, stdout, stderr) ->
      if err?
        if err.indexOf 'sshfs: command not found' > -1
          warn 'sshfs is not installed!'
          warn 'You can find it here: http://osxfuse.github.com'
        else
          warn 'Unexpected error:'
          warn err
      else
        write "Box mounted:\t#{path}"
  else
    write 'Please supply exactly one <boxName> argument'
    write 'Usage:'
    write '\tswbox mount <boxName>\tMount <boxName> as an sshfs drive'

unmountBox = ->
  args = process.argv[3..]
  if args.length == 1
    boxName = args[0]
    path = "/tmp/ssh/#{boxName}"
    exec "umount #{path}", (err, stdout, stderr) ->
      if err?
        if "#{err}".indexOf 'not currently mounted' > -1
          warn "Error: #{boxName} is not currently mounted"
        else
          warn 'Unexpected error:'
          warn err
      else
        write "Box unmounted:\t#{boxName}"
  else
    write 'Please supply exactly one <boxName> argument'
    write 'Usage:'
    write '\tswbox unmount <boxName>\tUnmount the <boxName> sshfs drive'

swbox =
  mount: mountBox
  unmount: unmountBox
  help: showHelp
  '--help': showHelp
  '-v': showVersion
  '--version': showVersion

main = ->
  args = process.argv
  if args.length > 2
    if args[2] of swbox
      swbox[args[2]]()
    else
      write "Sorry, I don’t understand ‘#{args[2]}’"
      write 'Try: swbox help'
  else
    swbox.help()

main()
