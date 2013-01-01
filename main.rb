require 'gosu'

require_relative 'window'
require_relative 'player'
require_relative 'star'


module ZOrder
    Background, Stars, Player, UI = *0..3
end


$screenWidth = 1024
$screenHeight = 768

$score = 0
$skillPoints = 0.0
$turboStatus = false

window = GameWindow.new
window.show