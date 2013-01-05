require 'gosu'

require_relative 'window'
require_relative 'player'
require_relative 'laser'
require_relative 'mine'

require_relative 'rock'
require_relative 'star'


module ZOrder
    Background, Stars, Rock, Laser, Player, UI = *0..5
end



$score = 0
$skillPoints = 100.0

$explodeStatus = false

$laserStatus = false
$missileStatus = false
$minesStatus = false


window = Window.new
window.show