class Rock
    attr_reader :x, :y

    def initialize(window)
        @window = window
        @icon = Gosu::Image.new(@window, "media/rock_large.png", true)
        @y = 0
        @x = rand(@window.width)
        @angle = 0.0
        @lifeStatus = true
        @reset = false
        @velocity = rand(1..3)
        @direction = rand(9)
    end

    def update
        if @reset
            @y = 0
            @x = rand(@window.width)
            @reset = false
            @lifeStatus = true
        else
            @y = @y + @velocity
            if @direction >= 5
                @x = @x + @velocity
            else
                @x = @x - @velocity
            end
            if @y > (@window.height + 100)  or @x > (@window.width + 100) or @x < (0 - 100)
                @y = 0
                @x = rand(@window.width)
                @velocity = rand(1..3)
                @direction = rand(9)
            end
        end
    end

    def draw
        if @lifeStatus
            if @direction >= 5
                @angle += @velocity
            else
                @angle -= 5.0
            end
            @icon.draw_rot(@x, @y, ZOrder::Rock, @angle)
        end
    end

    def hit_by?(laser)
        if Gosu::distance(laser.x, laser.y, @x, @y) < 100
            $score += 10
            @lifeStatus = false
            @reset = true
            @velocity = rand(1..3)
            @direction = rand(9)
        end
    end

end