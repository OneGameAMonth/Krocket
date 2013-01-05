class Window < Gosu::Window

    attr_reader :width, :height

    def initialize

        @width = 1024
        @height = 768

        $width = @width
        $height = @height

        super @width, @height, false
        self.caption = "Krocket"
        
        
        @pauseStatus = true
        @hudFont = Gosu::Font.new(self, Gosu::default_font_name, 25)
        @windowXCentre = @width / 2
        @windowYCentre = @height / 2

        @backgroundImage = Gosu::Image.new(self, "media/background_mars.png", true)
        @hudTopImage = Gosu::Image.new(self, "media/hud_top.png", true)
        @hudLeftImage = Gosu::Image.new(self, "media/hud_left.png", true)
        @hudRightImage = Gosu::Image.new(self, "media/hud_right.png", true)
        @pauseImage = Gosu::Image.new(self, "media/pause_screen.png", true)
        @turboSound = Gosu::Sample.new(self, "media/turbo.ogg")
        @laserSound = Gosu::Sample.new(self, "media/laser.wav")

        @player = Player.new(self)
        @player.warp(@windowXCentre, @height - 126)
        @rock = Rock.new(self)
        @stars = Array.new
        @starsAnimation = Gosu::Image::load_tiles(self, "media/star.png", 25, 25, false)
    end

    def update
        if !@pauseStatus
            @player.update
            @player.hit_by?(@rock)
            @rock.update
            @rock.hit_by?(@player.laser)
            $score += 0.02

            if $skillPoints < 0
                $skillPoints = 0
            end

            if $skillPoints > 100
                $skillPoints = 100
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
        if @pauseStatus == true
            @pauseImage.draw(@windowXCentre-333, @windowYCentre - 250, ZOrder::UI, 1.0, 1.0)
        end
        @backgroundImage.draw(0, 0, 0)
        @hudTopImage.draw(@windowXCentre - 102, 0, ZOrder::UI)
        @hudLeftImage.draw(0, (@height - 54), ZOrder::UI)
        @hudRightImage.draw(@width - 204, (@height - 54), ZOrder::UI)
        @player.draw
        @rock.draw
        @stars.each { |star| star.draw }
        if $score < 10
            @hudFont.draw("Score: 000#{$score.to_i}", @windowXCentre - 59, 12, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        elsif $score < 100
            @hudFont.draw("Score: 00#{$score.to_i}", @windowXCentre - 59, 12, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        elsif $score < 1000
            @hudFont.draw("Score: 0#{$score.to_i}", @windowXCentre - 59, 12, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        elsif $score > 999
            @hudFont.draw("Score: #{$score.to_i}", @windowXCentre - 59, 12, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        end

        if $skillPoints < 10
            @hudFont.draw("Power: 00#{$skillPoints.to_i}%", 30, @height -36, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        elsif $skillPoints < 100
            @hudFont.draw("Power: 0#{$skillPoints.to_i}%", 30, @height -36, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        elsif $skillPoints == 100
            @hudFont.draw("Power: #{$skillPoints.to_i}%", 30, @height -36, ZOrder::UI, 1.0, 1.0, 0xffffff00)
        end

    end

    def button_down(id)
        if id == Gosu::KbEscape
            if @pauseStatus == false
                @pauseStatus = true
            else
                close
            end
        end

        if id == Gosu::KbReturn
            if @pauseStatus == false
                @pauseStatus = true
            else
                @pauseStatus = false
            end
        end

        if id == Gosu::KbTab and $skillPoints > 0
            @turboSound.play
        end

        if id == Gosu::KbSpace and $skillPoints > 0
            if !$laserStatus
                $skillPoints -= 5
                @laserSound.play
            end
        end

        if id == Gosu::KbLeftControl and $skillPoints > 0
            if !$mineStatus
                $skillPoints -= 5
                @laserSound.play
            end
        end
    end
end