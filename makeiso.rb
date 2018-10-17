#!/usr/bin/env ruby

def look_for_target_disc()
  @new_mounted_drives = Dir.glob('/media/' + @user + '/*')
  @target_disc = (@new_mounted_drives - @old_mounted_drives)[0]
end

@user = `whoami`.chomp
# Find list of already mounted (non-target) drives
@old_mounted_drives = Dir.glob('/media/' + @user + '/*')
puts "Please insert DVD and press 'Enter' to continue, or type Q and press Enter to quit"
$exit_check = gets.chomp

# Start Loop for ripping
while $exit_check != 'Q'
  while @target_disc.nil?
    look_for_target_disc
  end
  puts @target_disc
  disc_id = File.basename(@target_disc,'.volume')
  Dir.mkdir(disc_id )
  puts disc_id + '.iso'
  system('umount /dev/sr0')
  system('ddrescue','-b 2048','-r4','-v','/dev/sr0',"#{disc_id}/#{disc_id}.iso","#{disc_id}/#{disc_id}.log")
  system('eject')
  @target_disc = nil
  puts "Please insert DVD and press 'Enter' to continue, or type Q and press Enter to quit"
  $exit_check = gets.chomp
end
