require_relative '../cache.weltfussball/lib/convert'



Worldfootball.config.sleep = 3

Worldfootball.config.cache.schedules_dir = '../cache.weltfussball/dl'
Worldfootball.config.cache.reports_dir   = '../cache.weltfussball/dl2'


RO = %w[
rou-liga-1-2020-2021

rou-liga-1-2019-2020
rou-liga-1-2019-2020-championship
rou-liga-1-2019-2020-relegation

rou-liga-1-2018-2019
rou-liga-1-2018-2019-championship
rou-liga-1-2018-2019-relegation

rou-liga-1-2017-2018
rou-liga-1-2017-2018-championship
rou-liga-1-2017-2018-relegation

rou-liga-1-2016-2017
rou-liga-1-2016-2017-championship
rou-liga-1-2016-2017-relegation

rom-liga-1-2015-2016
rom-liga-1-2015-2016-championship
rou-liga-1-2015-2016-relegation

rom-liga-1-2014-2015
rom-liga-1-2013-2014
rom-liga-1-2012-2013
rom-liga-1-2011-2012
rom-liga-1-2010-2011
]


MX = %w[
 mex-primera-division-2020-2021-apertura

 mex-primera-division-2019-2020-apertura
 mex-primera-division-2019-2020-apertura-playoffs
 mex-primera-division-2019-2020-clausura

 mex-primera-division-2018-2019-apertura
 mex-primera-division-2018-2019-apertura-playoffs
 mex-primera-division-2018-2019-clausura
 mex-primera-division-2018-2019-clausura-playoffs

 mex-primera-division-2017-2018-apertura
 mex-primera-division-2017-2018-apertura-playoffs
 mex-primera-division-2017-2018-clausura
 mex-primera-division-2017-2018-clausura-playoffs

 mex-primera-division-2016-2017-apertura
 mex-primera-division-2016-2017-apertura-playoffs
 mex-primera-division-2016-2017-clausura
 mex-primera-division-2016-2017-clausura-playoffs

 mex-primera-division-2015-2016-apertura
 mex-primera-division-2015-2016-apertura-playoffs
 mex-primera-division-2015-2016-clausura
 mex-primera-division-2015-2016-clausura-playoffs

 mex-primera-division-2014-2015-apertura
 mex-primera-division-2014-2015-apertura-playoffs
 mex-primera-division-2014-2015-clausura
 mex-primera-division-2014-2015-clausura-playoffs

 mex-primera-division-2013-2014-apertura
 mex-primera-division-2013-2014-apertura-playoffs
 mex-primera-division-2013-2014-clausura
 mex-primera-division-2013-2014-clausura-playoffs

 mex-primera-division-2012-2013-apertura
 mex-primera-division-2012-2013-apertura-playoffs
 mex-primera-division-2012-2013-clausura
 mex-primera-division-2012-2013-clausura-playoffs

 mex-primera-division-2011-2012-apertura
 mex-primera-division-2011-2012-apertura-playoffs
 mex-primera-division-2011-2012-clausura
 mex-primera-division-2011-2012-clausura-playoffs

 mex-primera-division-2010-2011-apertura
 mex-primera-division-2010-2011-apertura-playoffs
 mex-primera-division-2010-2011-clausura
 mex-primera-division-2010-2011-clausura-playoffs
]


# SLUGS = MX
SLUGS = RO

SLUGS.each_with_index do |slug,i|
  puts "[#{i+1}/#{SLUGS.size}]>#{slug}<"
  Worldfootball::Metal.schedule( slug )
end


puts "bye"
