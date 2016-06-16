
class Block
  def initialize(y, blockWidth,width,ySpeed,height)
    @image = Gosu::Image.new("img/red.png")
    @x, @y, @ySpeed, @hasControl = (width/2+20), y, ySpeed, true
    @blockWidth = blockWidth
    @height = height

  end

  def draw(depth)
    @image.draw_rot(@x, @y,depth,0)
  end

  def getX
    return @x
  end

  def getY
    return @y
  end


  def update
    if @hasControl
      if @y + @blockWidth < @height
        @y += @blockWidth
      else
        @hasControl = false
      end
    end
  end

  def controllable?
    return @hasControl
  end

  def moveLeft
    @x -= @blockWidth
  end

  def moveRight
    @x += @blockWidth
  end

  def disableBlock
    hasControl = false
  end


end
