require_relative '../boot'



# DATAFILES_DIR = '../../stage/two'
# DATAFILES_DIR = './o/at'
# DATAFILES_DIR = './o/de'
# DATAFILES_DIR = './o/fr'
# DATAFILES_DIR = './o/aug10'
DATAFILES_DIR = './o'

# DATAFILES_DIR = './tmp'


team_buf,   team_errors   = SportDb::TeamSummary.build( DATAFILES_DIR )

OUT_DIR = DATAFILES_DIR
# OUT_DIR  = './o'   ## for (local) debugging

File.open( "#{OUT_DIR}/SUMMARY.md", 'w:utf-8' )  { |f| f.write( team_buf ) }


puts "#{team_errors.size} error(s) - teams:"
pp team_errors

puts 'bye'

