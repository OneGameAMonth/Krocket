class Player
    attr_reader :score

    def initialize(window)
        @image = Gosu::Image.new(window, "media/starfighter_small2.png", false)
        @beep = Gosu::Sample.new(window, "media/beep.wav")
        @x = @y = @vel_x = @vel_y = @angle = 0.0
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def move_left
        @vel_x -= Gosu::offset_x(@angle*4, 0.25)
        @vel_y -= Gosu::offset_y(@angle*4, 0.25)
    end

    def move_right
        @vel_x += Gosu::offset_x(@angle*4, 0.25)
        @vel_y += Gosu::offset_y(@angle*4, 0.25)
    end

    def turn_left
        @angle -= 5
        # puts("Turning Left")
    end

    def turn_right
        @angle += 5
        # puts("Turning Right")
    end

    def accelerate
        if $turboStatus == true
            if $skillPoints > 0
                $skillPoints -= 0.5
            end

            if $skillPoints > 0
                @vel_x += Gosu::offset_x(@angle, 0.3)
                @vel_y += Gosu::offset_y(@angle, 0.3)
            end
            $turboStatus = false
        else
            @vel_x += Gosu::offset_x(@angle, 0.15)
            @vel_y += Gosu::offset_y(@angle, 0.15)
            # puts("Accelerating")
        end
    end

    def reverse
        @vel_x -= Gosu::offset_x(@angle, 0.15)
        @vel_y -= Gosu::offset_y(@angle, 0.15)
        # puts("Reversing")
    end

    def move
        @x += @vel_x
        @y += @vel_y
        @x %= $screenWidth
        @y %= $screenHeight

        @vel_x *= 0.95
        @vel_y *= 0.95
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle)
    end

    def skill_points
        $skillPoints
    end

    def collect_stars(stars)
        stars.reject! do |star|
            if Gosu::distance(@x, @y, star.x, star.y) < 35 then
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