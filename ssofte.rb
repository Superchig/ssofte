#!/usr/bin/env ruby
require "optparse"
require "fileutils"
require "io/console"

# TODO Find way to implement ck2 and eu4 mode
backup_directory = "#{Dir.home}/Documents/backup_saves"
save_directory = "#{Dir.home}/.local/share/Paradox Interactive/Europa Universalis IV/save games"

option = nil
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-c", "--copy", "Backups SAVE using name NAME") do
    option = :save
  end

  opts.on("-r", "--restore", "Restores from -r SRC to DEST") do
    option = :restore
  end

  opts.on("-l", "--list-backups", "Lists existing backups") do
    option = :list
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
  end
end.parse!

case option
when :save
  unless ARGV.count == 2
    puts "Usage: #{$0} -c NAME SAVE"
    exit(1)
  end

  if File.exist?("#{save_directory}/#{ARGV[0]}.eu4")
    puts "A backup by that name already exists. Are you sure you want to do that? (y/n)"

    char = STDIN.getch

    if char == "\u0003"
      exit(1)
    elsif char != "y"
      exit
    end
  end

  FileUtils.cp("#{save_directory}/#{ARGV[0]}.eu4", "#{backup_directory}/#{ARGV[1]}.eu4")
  puts "Backup created."
when :restore
  unless ARGV.count == 2
    puts "Usage: #{$0} -r SRC DEST"
    exit(1)
  end

  FileUtils.cp("#{backup_directory}/#{ARGV[0]}.eu4", "#{save_directory}/#{ARGV[1]}.eu4")
  puts "Saves restored."
when :list
  unless ARGV.count.zero?
    puts "Usage: #{$0} -l"
    exit(1) 
  end

  Dir.foreach("#{backup_directory}") { |backup| puts File.basename(backup, ".eu4") unless backup == "." || backup == ".." }
end
