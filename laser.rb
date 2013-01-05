class Laser

    attr_reader :x, :y

    def initialize(player, window)
        @player = player
        @window = window
        @x = @player.x
        @y = @player.y
        @vel_x = 0
        @vel_y = 0
        @icon = Gosu::Image.new(@window, "media/laser_red.png", true)
    end

    def shoot
        if $skillPoints > 0
            $laserStatus = true
        end

    end

    def update
        if $laserStatus
            @angle = @player.angle
            move()
        else
            @x = @player.x
            @y = @player.y
        end
    end

    def draw
        if $laserStatus
            @icon.draw_rot(@x, @y, ZOrder::Laser, @angle)
        else
            # @icon.draw_rot(@player.x, @player.y, 1, @player.angle)
        end
    end

    def move()
        @x += @vel_x
        @y += @vel_y

        @vel_x *= 0.95
        @vel_y *= 0.95

        @vel_x += Gosu::offset_x(@angle, 7)
        @vel_y += Gosu::offset_y(@angle, 7)

        if @y < 0 or @y > @window.height or @x < 0 or @x > @window.width
            $laserStatus = false
            @vel_x = 0.0
            @vel_y = 0.0
        end

    end
end