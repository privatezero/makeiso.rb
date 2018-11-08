def look_for_target_disk()
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
    look_for_target_disk
  end

  disc_id = File.basename(@target_disc,'.volume')
  @ffmpeg_targets = 'concat:'
  target_vobs = Array.new
  while target_vobs.empty?
    target_vobs = Dir.glob('/media/' + @user + '/' + disc_id + '/VIDEO_TS/*.VOB')
  end
  puts @target_disc
  puts disc_id
  puts target_vobs

  target_vobs.each do |vob_file|
    if vob_file == target_vobs.first
      @ffmpeg_targets = @ffmpeg_targets + vob_file
    else
      @ffmpeg_targets = @ffmpeg_targets +  '\\|' + vob_file
    end
  end
  puts @ffmpeg_targets
  desktop_path=File.expand_path('~/Desktop')
  system('ffmpeg -i ' + @ffmpeg_targets + ' -c copy -target ntsc-dvd ' + desktop_path + '/testoutput.mpg')
  system('eject')
  puts "Please insert DVD and press 'Enter' to continue, or type Q and press Enter to quit"
  $exit_check = gets.chomp
end
