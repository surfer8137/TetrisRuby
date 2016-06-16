require_relative 'block.rb'
require 'gosu'
require 'matrix'

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class BlockGenerator

  def initialize(yOrigin, blockWidth, width,height,blocks,speedMultiplier,blocksX,blocksY)
    @blockPlaying = false
    @currentBlock = nil
    @blockSpeed = 1/60.0 * speedMultiplier
    @backUpSpeed = 1/60.0 * speedMultiplier
    @yOrigin, @blockWidth, @width = yOrigin, blockWidth, width
    @moved = false
    @blocks = Array.new(blocks)
    @height = height
    @blocksX = blocksX
    @blocksY = blocksY
    @blockMatrix = Matrix.build(blocksX, blocksY) {|row, col| 0 }
  end

  def getSeconds
    return @blockSpeed
  end

  def setSpeed
    @blockSpeed = @backUpSpeed
  end

  def setSpeed2x
    @blockSpeed = @backUpSpeed / 2
  end

  def destroyBlock
    @blockMatrix[getXindex, getYindex] = 1
    @currentBlock.disableBlock
    @currentBlock = nil
    @blockPlaying = false
  end

  def createBlock
    @currentBlock = Block.new(@yOrigin, @blockWidth,@width,@blockSpeed,@height)
    @blocks << @currentBlock
    @blockPlaying = true
  end

  #1 step per second
  def update
    if !@blockPlaying
      createBlock
    end
    if @currentBlock != nil
      @currentBlock.update
      if !@currentBlock.controllable? || (getYindex - 1 >= 0 && @blockMatrix[getXindex, getYindex-1] == 1)
        destroyBlock
      end
    end
  end

  def updateCurrentBlock
    if @currentBlock != nil
      if @moved && !((Gosu::button_down?  Gosu::KbLeft) || (Gosu::button_down? Gosu::KbRight))
        @moved = false
      end
      if !@moved && (Gosu::button_down?  Gosu::KbLeft) && (getXindex < 9) && @blockMatrix[getXindex+1 ,getYindex] == 0
        @currentBlock.moveLeft
        @moved = true
      elsif !@moved && (Gosu::button_down? Gosu::KbRight) && (getXindex > 0) && @blockMatrix[getXindex-1,getYindex] == 0
        @currentBlock.moveRight
        @moved = true
      end
    end
  end

  def draw(depth)
    @blocks.each { |v|
      if v.instance_of? Block
        v.draw(depth)
      end
    }
  end

  def getXindex
    return ((@width * 0.9) - (@currentBlock.getX+20)).to_i / 60
  end

  def getYindex
    return (@height - @currentBlock.getY).to_i / 60
  end

end
