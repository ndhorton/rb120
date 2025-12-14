require 'psych'
[
  " --------- ",
  "|10     10|",
  "| x     x |",
  "| x  x  x |",
  "|         |",
  "| x  x  x |",
  "| x     x |",
  "|10     10|",
  " --------- "
]


RED = "\e[31m"
RESET = "\e[0m"


SPADE = "\u2660"
HOLLOW_SPADE = "\u2664"

CLUB = "\u2663"
HOLLOW_CLUB = "\u2667"

DIAMOND = "#{RED}\u2666#{RESET}"
HEART = "#{RED}\u2665#{RESET}"

UP_LEFT = "\u250c"
UP_RIGHT = "\u2510"
H_SIDE = "\u2500"
V_SIDE = "\u2502"
BT_LEFT = "\u2514"
BT_RIGHT = "\u2518"

SUITS = {
  diamonds: DIAMOND,
  hearts: HEART,
  clubs: HOLLOW_CLUB,
  spades: HOLLOW_SPADE
}

FACES = {
  ace: 'A',
  king: 'K',
  queen: 'Q',
  jack: 'J',
  10 => '10',
  9 => '9',
  8 => '8',
  7 => '7',
  6 => '6',
  5 => '5',
  4 => '4',
  3 => '3',
  2 => '2',
  1 => '1'
}

VISUAL_CARDS = {
  'A' => 'ace',
  'K' => 'royal',
  'Q' => 'royal',
  'J' => 'royal',
  10 => 'ten',
  9 => 'nine',
  8 => 'eight',
  7 => 'seven',
  6 => 'six',
  5 => 'five',
  4 => 'four',
  3 => 'three',
  2 => 'two',
}

input_cards = [[5, :diamonds], [5, :clubs], [:ace, :spades], [:jack, :clubs], [:queen, :hearts]]
output_cards = []

TEXT_ART = Psych.load_file("#{__dir__}/twenty_one_card_art.yaml")
# input_cards.each do |face, suit|
#   type = TYPES[face]
#   face = FACES[face]
#   face = "#{RED}#{face}#{RESET}" if [:hearts, :diamons].include?(suit)
#   suit = DIAMOND if suit == :diamonds
#   suit = HEART if suit == :hearts
#   output_cards << TEXT_ART[type].map { |line| line % { face: face, suit: suit} }
# end

# (0...output_cards.size).each do |line_index|
#   line = ''
#   output_cards.each { |card| line << ' ' << card[line_index] }
#   puts line
# end
cards = []
# cards << TEXT_ART['royal'].map { |line| line % {face: 'K', suit: HOLLOW_CLUB} }
# cards << TEXT_ART['royal'].map { |line| line % {face: 'K', suit: HOLLOW_CLUB} }
cards << TEXT_ART['ten'].map { |line| line % {face: "#{RED}10#{RESET}", suit: HEART } }
cards << TEXT_ART['five'].map { |line| line % {face: '5', suit: HOLLOW_SPADE} }
cards << TEXT_ART['seven'].map { |line| line % {face: "#{RED}7#{RESET}", suit: DIAMOND }}
# cards << TEXT_ART['turned']
# cards << TEXT_ART['turned']

(0...cards.first.size).each do |line_index|
  line = ''
  cards.each { |card| line << ' ' << card[line_index] }
  puts line
end

# puts TEXT_ART['ten'].join("\n") % { face: '10', suit: HEART }

# so you can fit 6 cards per terminal line
# so in some rare cases you could need two card lines for your deck and two for dealer
# so something like 
#`card_groups = output_cards.each_slice(6).to_a`
# Then treat each card_group as a card line