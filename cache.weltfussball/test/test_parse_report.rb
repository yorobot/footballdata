###
# test parse match report from page

require_relative '../lib/metal'


%w[2-liga-2019-2020-fc-juniors-ooe-fc-liefering
   2-liga-2019-2020-vorwaerts-steyr-sk-austria-klagenfurt
   2-liga-2019-2020-vorwaerts-steyr-sv-lafnitz
  ].each do |slug|
  page = Worldfootball::Page::Report.from_cache( slug )

  puts
  puts page.title
  puts page.generated

  rows = page.goals
  puts "goals - #{rows.size} records"
  pp rows
end

puts "bye"