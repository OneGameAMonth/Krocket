class Star
    attr_reader :x, :y

    def initialize(animation)
        @animation = animation
        @colour = Gosu::Color.new(0xff000000)
        @colour.red = rand(256 - 40) + 40
        @colour.green = rand(256 - 40) + 40
        @colour.blue = rand(256 - 40) + 40
        @x = rand * ($width - 50)
        @y= rand * ($height - 50)
    end

    def draw
        img = @animation[Gosu::milliseconds / 100 % @animation.size];
        img.draw(@x -img.width / 2.0, @y -img.height / 2.0,
                 ZOrder::Stars, 1, 1, @colour, :add)
    end
end