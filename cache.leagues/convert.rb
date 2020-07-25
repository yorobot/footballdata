require_relative '../csv'        ## pull in date_to_season helper


OUT_DIR = './o'
# OUT_DIR = '../../../footballcsv/cache.leagues'


MODS = {
  'es.2' => {
         'Extremadura' => 'Extremadura UD'  # in season 2019/20
            },
  'ar.1' => {
          'San Martin' => 'San Martín T.'  # in season 2018/19
           },
}



datafiles = Dir.glob( "./dl/fbref/**/*csv" )
puts "#{datafiles.size} datafiles"

datafiles.each do |datafile|

# sample datfile format style:
#    Wk,Day,Date,Time,Home,Score,Away,Attendance,Venue,Referee,Match Report,Notes
#    1,Sat,2010-08-14,,Bolton,0–0,Fulham,,,,Match Report,
#    1,Sat,2010-08-14,,Wigan Athletic,0–4,Blackpool,,,,Match Report,

    basename = File.basename( datafile, File.extname( datafile) )
    dirname  = File.basename( File.dirname( datafile ))

    mods = MODS[ basename ] || {}

    puts "#{dirname}/#{basename}: (#{datafile})"
    rows = CsvHash.read( datafile, :header_converters => :symbol )

    ## convert to records
    recs = []

    rows.each do |row|
#    Wk,Day,Date,Time,Home,Score,Away,Attendance,Venue,Referee,Match Report,Notes
#    1,Sat,2010-08-14,,Bolton,0–0,Fulham,,,,Match Report,
       next if row[:home].empty? && row[:away].empty?   # skip empty "filler" rows

       ## note: replace unicode "fancy" dash with ascii-dash
       #  check other columns too - possible in teams?
       row[:score] = row[:score].gsub( /[–]/, '-' )


       values = []

       team1 = row[:home]
       team2 = row[:away]

       ### mods - rename club names
       unless mods.nil? || mods.empty?
         team1 = mods[ team1 ]      if mods[ team1 ]
         team2 = mods[ team2 ]      if mods[ team2 ]
       end


       if basename == 'at.1' && row.key?( :round )   ## todo/fix: check starting with season 2018/19!!!
         case row[:round]
         when 'Relegation round','Championship round'
           # add 22 e.g. 1+22 => 23 matchday
           values << (row[:round].start_with?( 'Relegation' ) ?
                       'Finaldurchgang - Qualifikation' :
                       'Finaldurchgang - Meister')
           values << (row[:wk].to_i + 22).to_s
         when 'Semi-final', 'Finals'
           values << 'Europa League Play-off'
           values << (row[:round].start_with?( 'Semi' ) ?
                       'Halbfinale' :
                       'Finale' )
         else  ## asumme 'Regular Season'
           values << 'Grunddurchgang'
           values << row[:wk]
         end
       elsif basename == 'au.1' && row.key?( :round )
         ## todo/fix: how to handle et/pen score in finals e.g. (1) 0–0 (4) !!!!
         ##    check if same in champions league?
         ##   check for extra time in notes
         case row[:round]
         when 'Elimination finals', 'Semi-finals', 'Grand Final'
           values << 'Finals'
           values << row[:round]
         else  ## asumme 'Regular Season'
           values << 'Regular Season'
           values << row[:wk]
         end
       else  ## regular processing
         values << row[:wk]                  # matchday
       end

       values << Date.strptime( row[:date], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' )   # e.g. Sat Aug 7 1993
       values <<  if row[:time].empty?     # time
                       '?'
                  else
                    ## e.g. 15:00 (16:00)  remove own time (only use local to venue)
                    #   note: use non-greedy (minimal) match e.g. .+?
                      row[:time].gsub( /\(.+?\)/, '' ).strip
                  end
        values << team1    # team 1
        values << row[:score]   # ft
        values <<   if row[:score].empty?   # assume match still in future
                      ''
                    else
                      '?'          # ht
                    end
        values << team2    # team 2


       recs << values
    end
    puts "  #{recs.size} records  (from #{rows.size} rows)"


    out_path = "#{OUT_DIR}/#{dirname}/#{basename}.csv"

    headers = if recs[0].size == 7   ## assume "standard" league format
                ['Matchday',
                 'Date',
                 'Time',
                 'Team 1',
                 'FT',
                 'HT',
                 'Team 2'
                ]
              else  ## assume stage & "non-regular" rounds (NOT all matchdays, that is, numbers)
                ['Stage',
                 'Round',
                 'Date',
                 'Time',
                 'Team 1',
                 'FT',
                 'HT',
                 'Team 2'
                ]
              end

    Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end


puts "bye"