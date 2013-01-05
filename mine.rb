class Mine
    def initialize(player, window)
        @player = player
        @window = window
        @x = @player.x
        @y = @player.y
        @vel_x = 0.0
        @vel_y = 0.0
        @angle = @player.angle
        @icon = Gosu::Image.new(@window, "media/laser_green.png", true)
    end

    def shoot
        if $skillPoints > 0
            $mineStatus = true
        end

    end

    def update
        if $mineStatus
            move
            if @y < 0
                $mineStatus = false
            end
        else
            @x = @player.x
            @y = @player.y
        end
    end

    def draw
        if $mineStatus
            @icon.draw(@x, @y, 4)
        else
            # @icon.draw_rot(@player.x, @player.y, 1, @player.angle)
        end
    end

    def move
        @x += @vel_x
        @y += @vel_y
        @x %= @window.width
        @y %= @window.height

        @vel_x *= 0.95
        @vel_y *= 0.95
    end
end