require_relative 'lib/convert'


OUT_DIR='./o'
# OUT_DIR='../../stage/two'

# OUT_DIR='./o/test'
# OUT_DIR='./tmp'


start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


# pages = Dir.glob( './dl/at*' )
pages = Dir.glob( './dl/*' )

puts "#{pages.size} pages"
puts


leagues = {}

pages.each do |path|
   basename = File.basename( path, File.extname( path ) )
   print "%-40s" % basename
   print " => "

   page = Worldfootball.find_page( basename )
   league_key = page[:league]
   season_key = page[:season]

   print "    "
   print "%-12s"    % league_key
   print "| %-10s"  % season_key
   print "\n"

   seasons = leagues[league_key] ||= []
   seasons << season_key   unless seasons.include?( season_key )
end

pp leagues


###
## convert
##  todo/fix:
##    time offset (e.g -7 for Mexico) and others missing!!!
##  add somehow!!!


leagues.each do |key,seasons|
  puts "  #{key} - #{seasons.size} seasons (#{seasons.join(' ')}):"

  ## note: skip english league cup for now; needs score format fix (no extra time but penalties)
  ##  [010] 1. Runde => Round 1
  ##  [010]    2019-08-13 | 20:45 | Blackpool FC           | Macclesfield Town      | 2-4 (1-1, 2-2) i.E.
  ##  !! ERROR - unsupported score format >2-4 (1-1, 2-2) i.E.< - sorry
  next if ['eng.cup.l'].include?( key )

  seasons.each do |season|
    puts "    convert( league: '#{key}', season: '#{season}' )"
    convert( league: key, season: season )
  end
end


## print stats
puts
puts
puts "#{leagues.size} leagues:"
leagues.each do |key,seasons|
  puts "  #{key} - #{seasons.size} season(s) (#{seasons.join(' ')})"
end


end_time = Time.now
diff_time = end_time - start_time
puts "convert_all: done in #{diff_time} sec(s)"

puts "bye"
