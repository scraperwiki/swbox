#!/usr/bin/env coffee

write = (text) ->
  process.stdout.write "#{text}\n"

showVersion = ->
  write 'swbox 0.0.1'
  write '© Zarino Zappia, AGPL Licensed'

showHelp = ->
    write 'swbox:\tA command line interface for interacting with ScraperWiki boxes'
    write 'Usage:\tswbox <command> [args]'
    write 'Commands:'
    write '\tswbox help\t\tShow this help'
    write '\tswbox [-v|--version]\tShow version'

swbox =
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
