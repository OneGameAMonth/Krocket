class Player
    attr_reader :x, :y, :vel_x, :vel_y, :angle, :laser

    def initialize(window)
        @window = window
        @icon = Gosu::Image.new(window, "media/rocket_normal.png", false)
        @beep = Gosu::Sample.new(window, "media/beep.wav")
        @bumpSound = Gosu::Sample.new(window, "media/bump.ogg")
        @explosion = Gosu::Image.new(window, "media/rocket_explosion.png", true)
        @laser = Laser.new(self, @window)
        @mine = Mine.new(self, @window)

        @x = @y = @vel_x = @vel_y = @angle = 0.0
    end

    def update
        controls
        @laser.update
        @mine.update
    end

    def draw
        if $explodeStatus
            @explosion.draw_rot(@x, @y, ZOrder::Player, @angle)
        else
            @icon.draw_rot(@x, @y, ZOrder::Player, @angle)
            @laser.draw
            @mine.draw
        end
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def controls
        # Player turning controls
        if @window.button_down? Gosu::KbA or @window.button_down? Gosu::GpLeft then
            @angle -= 5.0
            if @angle < (- 360)
                @angle = 0
            end
            puts("#{@angle}")
        end
        if @window.button_down? Gosu::KbD or @window.button_down? Gosu::GpRight then
            @angle += 5.0
            if @angle > (360)
                @angle = 0
            end
            puts("#{@angle}")
        end

        # Player forwards movement controls
        if @window.button_down? Gosu::KbW or @window.button_down? Gosu::GpButton0 then
                @vel_x += Gosu::offset_x(@angle, 0.15)
                @vel_y += Gosu::offset_y(@angle, 0.15)
                # puts("Accelerating")
        end

        if @window.button_down? Gosu::KbTab then
                if $skillPoints > 0
                    $skillPoints -= 0.5
                    @vel_x += Gosu::offset_x(@angle, 0.3)
                    @vel_y += Gosu::offset_y(@angle, 0.3)
                end
        end

        # Player backwards movement controls
        if @window.button_down? Gosu::KbS or @window.button_down? Gosu::GpButton0 then
            @vel_x -= Gosu::offset_x(@angle, 0.15)
            @vel_y -= Gosu::offset_y(@angle, 0.15)
            # puts("Reversing")
        end

        if @window.button_down? Gosu::KbSpace
            @laser.shoot
        end

        if @window.button_down? Gosu::KbLeftControl
            @mine.shoot
        end
    end


    def move
        @x += @vel_x
        @y += @vel_y
        @x %= @window.width
        @y %= @window.height

        @vel_x *= 0.97
        @vel_y *= 0.97
    end

    def hit_by?(rock)
        if Gosu::distance(rock.x, rock.y, @x, @y) < 60
            $explodeStatus = true
            @bumpSound.play
        else
            $explodeStatus = false
        end
    end

    def collect_stars(stars)
        stars.reject! do |star|
            if Gosu::distance(@x, @y, star.x, star.y) < 52 then
                $score += 10
                if $skillPoints >= 100
                    $skillPoints = 100
                else
                    $skillPoints += 10
                end
                @beep.play
                true
            else
                false
            end
        end
    end
end