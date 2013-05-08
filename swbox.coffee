#!/usr/bin/env coffee

fs = require 'fs' 

__version = '0.0.6'

exec = require('child_process').exec

write = (text) ->
  process.stdout.write "#{text}\n"

warn = (text) ->
  process.stderr.write "#{text}\n"

showVersion = ->
  write "swbox #{__version}"
  write '© Zarino Zappia, AGPL Licensed'

showHelp = ->
    write 'swbox:  A command line interface for interacting with ScraperWiki boxes'
    write 'Usage:  swbox command <required_argument> [optional_argument]'
    write 'Commands:'
    write '    swbox mount <boxName>    Mount <boxName> as an sshfs drive'
    write '    swbox unmount <boxName>  Unmount the <boxName> sshfs drive'
    write '    swbox clone <boxName>    Make a local copy of the entire contents of <boxName>'
    write '                               (into a directory called <boxName> in the current working directory)'
    write '    swbox push               Push changes from a local clone of a box back up to the original box'
    write '    swbox update             Download latest version of swbox'
    write '    swbox -v|--version       Show version & license info'
    write '    swbox help               Show this documentation'

mountBox = ->
  args = process.argv[3..]
  if args.length == 1
    boxName = args[0]
    path = "/tmp/ssh/#{boxName}"
    exec "mkdir -p #{path} && sshfs #{boxName}@box.scraperwiki.com:. #{path} -ovolname=#{boxName} -oBatchMode=yes -oworkaround=rename,noappledouble", {timeout: 5000}, (err, stdout, stderr) ->
      if err?
        if "#{err}".indexOf('sshfs: command not found') > -1
          warn 'sshfs is not installed!'
          warn 'You can find it here: http://osxfuse.github.com'
        else if "#{err}".indexOf('remote host has disconnected') > -1
          warn 'Error: The box server did not respond.'
          warn "The box ‘#{boxName}’ might not exist, or your SSH key might not be associated with it."
          warn 'Make sure you can see the box in your Data Hub on http://x.scraperwiki.com'
          exec "rmdir #{path}", (err) ->
            if err? then warn "Additionally, we enountered an error while removing the temporary directory at #{path}"
        else
          warn 'Unexpected error:'
          warn err
      else
        write "Box mounted:\t#{path}"
  else
    write 'Please supply exactly one <boxName> argument'
    write 'Usage:'
    write '    swbox mount <boxName>    Mount <boxName> as an sshfs drive'

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
    write '    swbox unmount <boxName>    Unmount the <boxName> sshfs drive'

cloneBox = ->
  args = process.argv[3..]
  if args.length == 1
    boxName = args[0]
    write "Cloning box ‘#{boxName}’ to directory #{process.cwd()}/#{boxName}..."
    # command = """scp -r -o "BatchMode yes" #{boxName}@box.scraperwiki.com:~ #{process.cwd()}/#{destination}"""
    command = """rsync -avx --delete-excluded --exclude='.DS_Store' -e 'ssh -o "NumberOfPasswordPrompts 0"' #{boxName}@box.scraperwiki.com:. #{process.cwd()}/#{boxName}"""
    exec command, (err, stdout, stderr) ->
      if stderr.match /^Permission denied/
        warn 'Error: Permission denied.'
        warn "The box ‘#{boxName}’ might not exist, or your SSH key might not be associated with it."
        warn 'Make sure you can see the box in your Data Hub on http://x.scraperwiki.com'
      else if err or stderr
        warn "Unexpected error:"
        warn err or stderr
      else
        write "Saving settings into #{boxName}/.swbox..."
        settings =
          boxName: boxName
        fs.writeFileSync "#{boxName}/.swbox", JSON.stringify(settings, null, 2)
        write "Box cloned to #{boxName}"
  else
    write 'Please supply a <boxName> argument'
    write 'Usage:'
    write '    swbox clone <boxName>    Make a local copy of the entire contents of <boxName>'
    write '                             (into a directory called <boxName> in the current working directory)'

pushBox = ->
  dir = process.cwd()
  walkUp = ->
    dir = dir.split('/').reverse()[1..].reverse().join '/'
  # Loop up through parent directories until we either
  # find a .swbox file, or we run out of directories
  walkUp() until ( dir == '' or fs.existsSync "#{dir}/.swbox" )
  if dir
    settings = JSON.parse( fs.readFileSync "#{dir}/.swbox", "utf8" )
    if settings.boxName
      boxName = settings.boxName
      command = """rsync -avx --itemize-changes --delete-excluded --exclude='.DS_Store' -e 'ssh -o "NumberOfPasswordPrompts 0"' "#{dir}/" #{boxName}@box.scraperwiki.com:."""
      exec command, (err, stdout, stderr) ->
        if stderr.match /^Permission denied/
          warn 'Error: Permission denied.'
          warn "The box ‘#{boxName}’ might not exist, or your SSH key might not be associated with it."
          warn 'Make sure you can see the box in your Data Hub on http://x.scraperwiki.com'
        else if err or stderr
          warn "Unexpected error:"
          warn err or stderr
        else
          write "Applying changes from #{dir}/ to #{boxName}@box.scraperwiki.com..."
          rsyncSummary stdout
    else
      warn "Error: Settings file at #{dir}/.swbox does not contain a boxName value!"
  else
    warn "Error: I don‘t know where I am!"
    warn "You must run this command from within a local clone of a ScraperWiki box."

rsyncSummary = (output) ->
  # output should be the stdout from an `rsync --itemize-changes` command
  lines = output.split('\n')
  for line in lines
    file = line.replace /^\S+ /, ''
    if line.indexOf('<') == 0
      write "\u001b[32m▲ #{file}\u001b[0m"
    else if line.indexOf('>') == 0
      write "\u001b[33m▼ #{file}\u001b[0m"
    else if line.indexOf('*deleting') == 0
      write "\u001b[31m– #{file}\u001b[0m"

update = ->
  exec "cd #{__dirname}; git pull", (err, stdout, stderr) ->
    if "#{stdout}".indexOf 'Already up-to-date' == 0
      write "You're already running the latest version of swbox"
    else if not stderr
      write 'swbox has been updated!'
    else
      warn 'Error: could not update.'
      warn stderr

swbox =
  mount: mountBox
  unmount: unmountBox
  clone: cloneBox
  push: pushBox
  help: showHelp
  update: update
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
