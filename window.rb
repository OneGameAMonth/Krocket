class GameWindow < Gosu::Window
    def initialize
        super $screenWidth, $screenHeight, false
        self.caption = "Krocket"

        @pause = true

        @backgroundImage = Gosu::Image.new(self, "media/background_mars.png", true)
        @pauseImage = Gosu::Image.new(self, "media/krocketbanner.png", true)

        @turboSound = Gosu::Sample.new(self, "media/turbo.ogg")

        @playerXSpawn = $screenWidth / 2
        @playerYSpawn = $screenHeight / 2

        @player = Player.new(self)
        @player.warp(@playerXSpawn, @playerYSpawn)

        @stars = Array.new
        @starsAnimation = Gosu::Image::load_tiles(self, "media/star.png", 25, 25, false)

        @scoreFont = Gosu::Font.new(self, Gosu::default_font_name, 25)
        @hudFont = Gosu::Font.new(self, Gosu::default_font_name, 35)

        @mousePosition = mouse_x
    end

    def button_down(id)
        if id == Gosu::KbEscape
            if @pause == false
                @pause = true
            else
                close
            end
        end
        if id == Gosu::KbReturn
            if @pause == false
                @pause = true
            else
                @pause = false
            end
        end
        if id == Gosu::KbTab and $skillPoints > 0
            @turboSound.play
        end
    end

    def update
        if @pause == false
            $score += 0.02
            if $skillPoints >= 100
                $skillPoints = 100
            end

            # Player turning controls
            if @mousePosition > mouse_x or button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
                @player.turn_left
                @mousePosition = mouse_x
            end
            if @mousePosition < mouse_x or button_down? Gosu::KbRight or button_down? Gosu::GpRight then
                @player.turn_right
                @mousePosition = mouse_x
            end

            # Player sideways movement controls
            if button_down? Gosu::KbA or button_down? Gosu::GpLeft then
                @player.turn_left
            end
            if button_down? Gosu::KbD or button_down? Gosu::GpRight then
                @player.turn_right
            end

            # Player forwards movement controls
            if button_down? Gosu::KbUp or button_down? Gosu::KbW or button_down? Gosu::GpButton0 then
                @player.accelerate
            end

            if button_down? Gosu::KbW and button_down? Gosu::KbTab then
                $turboStatus = true
                @player.accelerate
            end

            # Player backwards movement controls
            if button_down? Gosu::KbDown or button_down? Gosu::KbS or button_down? Gosu::GpButton0 then
                @player.reverse
            end

            # Miscellaneous update tasks
            @player.move
            @player.collect_stars(@stars)

            if rand(100) < 2 and @stars.size < 8 then
                @stars.push(Star.new(@starsAnimation))
            end
        end

    end

    def draw
        if @pause == true
            @pauseImage.draw(@playerXSpawn-200, @playerYSpawn - 75, ZOrder::UI, 1.0, 1.0)
        end
        @player.draw
        @backgroundImage.draw(0, 0, 0)
        @stars.each { |star| star.draw }
        @scoreFont.draw("Score: #{$score.to_i}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        @hudFont.draw("Power: #{$skillPoints.to_i}%", 10, $screenHeight -35, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    end
end