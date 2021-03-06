import GlassJoe from require 'src/opponents/glass_joe'
import FistTracking from require 'src/input/fist_tracking'
import Fist from require 'src/input/fist'

class MainGame
  new: =>

  load: =>
    @opponent = GlassJoe!
    @fistTracking = FistTracking(@opponent\face())

  draw: =>
    @opponent\draw()

  update: (dt) =>
    @opponent\update(dt)
    @opponent.hitRight = false
    @opponent.hitLeft = false

  touchpressed: (id, x, y, dx, dy, pressure) =>
    fist = @fistTracking\createFist(id, x, y, dx, dy, pressure)
    @fistTracking\startTracking(fist)

  touchmoved: (id, x, y, dx, dy, pressure) =>
    fist = @fistTracking\findFist(id)
    fist\update(x, y, dx, dy, pressure)
    if @fistTracking\didHitUpperToRight()
      @opponent.hitRight = true
    if @fistTracking\didHitUpperToLeft()
      @opponent.hitLeft = true

  touchreleased: (id, x, y, dx, dy, pressure) =>
    fist = @fistTracking\findFist(id)
    @fistTracking\endTracking(fist)

{:MainGame}
