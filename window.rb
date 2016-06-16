require 'gosu'
require_relative 'blockmatrix.rb'
require_relative 'blockgenerator.rb'

module ZOrder
  Background, Matrix,Block,UI = *0..3
end

class GameWindow < Gosu::Window
  def initialize
    super 800, 600, true
    @debug = true
    self.caption = "Game"
    @font = Gosu::Font.new(20)

    @img = "img/matrix_block.png"
    @blockSize = 60
    @percentagew = width * 0.80
    @blocksX = (@percentagew / @blockSize).to_i
    @blocksY = (height/@blockSize).to_i
    @multiplier = 10
    @backUpMultiplier = @multiplier
    @blockMatrix = BlockMatrix.new(@img,@blocksX,@blocksY,width*0.15,@blockSize/2,@percentagew,height)
    @blockGenerator = BlockGenerator.new(@blockSize/2,@blockSize,width,height,@blocksX * @blocksY, @multiplier,@blocksX,@blocksY)
    updateTime

    @pause = false
    @before = false

  end

  def update
    if !@pause
      @blockGenerator.updateCurrentBlock
      if(@currentTime >= @timeToReset)
        @blockGenerator.update
        updateTime
      end
      @currentTime = Time.now.to_f

      if Gosu::button_down? Gosu::KbDown
          @blockGenerator.setSpeed2x
      else
          @blockGenerator.setSpeed
      end
    end

    checkPause
    checkExit

  end

  def draw
    if @debug
    #Show fps
     @font.draw("fps: #{Gosu.fps} ", 0,height/100,ZOrder::UI, 0.75, 0.75, 0xff_ffff00)
     @font.draw("Stopped?: #{@pause? "Si":"No"} ", 0,20,ZOrder::UI, 0.75, 0.75, 0xff_ffffff)
   end
     @blockMatrix.draw(ZOrder::Matrix)
     @blockGenerator.draw(ZOrder::Block)
  end

  def updateTime
    @currentTime =  Time.now.to_f
    @timeToReset = (Time.now.to_f + @blockGenerator.getSeconds)
  end

  def checkPause
    if @before && !(Gosu::button_down? Gosu::KbP)
      @before = false
    end
    if (Gosu::button_down? Gosu::KbP) && !@before
      @pause = !@pause
      puts "Pausing..."
      @before = true
    end
  end

  def checkExit
    if Gosu::button_down? Gosu::KbEscape
        abort("Exiting...")
    end
  end


end

window = GameWindow.new
window.show
