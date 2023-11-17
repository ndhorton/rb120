ROCK_RULE = {
  'scissors' => true,
  'lizard' => true
}
ROCK_RULE.default = false
PAPER_RULE = {
  'rock' => true,
  'spock' => true
}
PAPER_RULE.default = false
SCISSORS_RULE = {
  'paper' => true,
  'lizard' => true
}
SCISSORS_RULE.default = false
LIZARD_RULE = {
  'spock' => true,
  'paper' => true
}
LIZARD_RULE.default = false
SPOCK_RULE = {
  'rock' => true,
  'scissors' => true
}
SPOCK_RULE.default = false

p ROCK_RULE['lizard']
p ROCK_RULE['paper']

p SPOCK_RULE['rock']
p SPOCK_RULE['lizard']
