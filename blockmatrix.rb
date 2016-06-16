require 'set'

class BlockMatrix

  def initialize(imgpath, blocksX, blocksY, x,y,width,height)
    @blocksX, @blocksY, @x, @y, @width, @height = blocksX, blocksY,x,y,width,height

    @img = Gosu::Image.new(imgpath)
    @blockSize = @img.width
    @blocks = Array(@blocksX * @blocksY)

    @blocksX.times{|i|
      @blocksY.times{|j|
        @blocks[i*@blocksX + j] = Gosu::Image.new(@img)
      }
   }
  end

  def draw(depth)
    @blocksX.times{|i|
      @blocksY.times{|j|
        @blocks[i*@blocksX + j].draw_rot(i * @blockSize + @x, @blockSize * j+ @y,depth,0)
      }
    }
  end



end
