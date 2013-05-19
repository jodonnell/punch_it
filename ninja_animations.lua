require 'class'
require 'constants'

NinjaAnimations = class()

function NinjaAnimations:init(ninja)
	 self.timer = 0;
	 self.currentImage = 'standing';
	 self.direction = RIGHT;
	 self.ninja = ninja

	 self.wasDucking = false

	 self.images = { standing = love.graphics.newImage("images/ryu_stand.png"),
									 running1 = love.graphics.newImage("images/ryu_running_1.png"),
									 running2 = love.graphics.newImage("images/ryu_running_2.png"),
									 running3 = love.graphics.newImage("images/ryu_running_3.png"),
									 ducking = love.graphics.newImage("images/ryu_ducking.png"),
									 jumping1 = love.graphics.newImage("images/ryu_right_jump.png"),
									 jumping2 = love.graphics.newImage("images/ryu_down_jump.png"),
									 jumping3 = love.graphics.newImage("images/ryu_left_jump.png"),
									 jumping4 = love.graphics.newImage("images/ryu_up_jump.png"),
									 attacking1 = love.graphics.newImage("images/ryu_attack_begin.png"),
									 attacking2 = love.graphics.newImage("images/ryu_attack_middle.png"),
									 attacking3 = love.graphics.newImage("images/ryu_attack_end.png"),
									 falling = love.graphics.newImage("images/ryu_falling_attack_begin.png"),
									 fallingAttack1 = love.graphics.newImage("images/ryu_falling_attack_middle.png"),
									 fallingAttack2 = love.graphics.newImage("images/ryu_falling_attack_end.png"),
									 hurt = love.graphics.newImage("images/ryu_hurt.png"),
	 }
end

function NinjaAnimations:changeAnimation()
	 self.timer = self.timer + 1

	 if self:isAttacking() then
			self:attackingAnimation()
	 elseif self:isAttackFalling() then
			self:attackFallingAnimation()
	 elseif self:isMovingRight() or self:isMovingLeft() then
			self:runningAnimation()
	 elseif self:isJumping() then
			self:jumpingAnimation()
	 end
end

function NinjaAnimations:attackFallingAnimation()
	 if self.timer == 5 then
	 		self.currentImage = 'fallingAttack2'
	 elseif self.timer == 9 then
	 		self.ninja.isAttacking = false
			self.currentImage = '' -- to force fall not return early
			self:fall()
	 end

end

function NinjaAnimations:attackingAnimation()
	 if self.timer == 1 then
			self.currentImage = 'attacking1'
	 elseif self.timer == 5 then
	 		self.currentImage = 'attacking2'
	 elseif self.timer == 9 then
	 		self.currentImage = 'attacking3'
	 elseif self.timer > 12 then
	 		self.ninja.isAttacking = false

			if self.ninja.rightPressed == false and self.ninja.leftPressed == false then
				 self.currentImage = 'standing'
			end
	 end
end

function NinjaAnimations:runningAnimation()
	 if self.timer == 1 then
			self.currentImage = 'running1'
	 elseif self.timer == 5 then
			self.currentImage = 'running2'
	 elseif self.timer == 9 then
			self.currentImage = 'running3'
	 elseif self.timer == 12 then
			self.timer = 0
	 end
end

function NinjaAnimations:jumpingAnimation()
	 if (self.timer % 3) == 0 then
			if self.currentImage == 'jumping1' then
				 self.currentImage = 'jumping2'
			elseif self.currentImage == 'jumping2' then
				 self.currentImage = 'jumping3'
			elseif self.currentImage == 'jumping3' then
				 self.currentImage = 'jumping4'
			else
				 self.currentImage = 'jumping1'
			end
	 end
end

function NinjaAnimations:isAttacking()
	 return self.currentImage == 'attacking1'
			or self.currentImage == 'attacking2'
			or self.currentImage == 'attacking3'
end

function NinjaAnimations:isFalling()
	 return self.currentImage == 'falling'
end

function NinjaAnimations:isAttackFalling()
	 return self.currentImage == 'fallingAttack1' or self.currentImage == 'fallingAttack2'
end

function NinjaAnimations:isMovingRight()
	 return self.direction == RIGHT and (self.currentImage == 'running1' or 
																			 self.currentImage == 'running2' or
																			 self.currentImage == 'running3')
end

function NinjaAnimations:isJumping()
	 return self.currentImage == 'jumping1'
			or self.currentImage == 'jumping2'
			or self.currentImage == 'jumping3'
			or self.currentImage == 'jumping4'
end

function NinjaAnimations:isMovingLeft()
	 return self.direction == LEFT and (self.currentImage == 'running1' or 
																			self.currentImage == 'running2' or
																			self.currentImage == 'running3')
end

function NinjaAnimations:getCurrentImage()
	 return self.images[self.currentImage]
end

function NinjaAnimations:stand()
	 if self:isAttacking() then
			return
	 end

	 self.currentImage = 'standing'
	 self:correctAdjustments()
end

function NinjaAnimations:fall()
	 if self:isFalling() or self:isAttackFalling() then
			return
	 end

	 self.currentImage = 'falling'
	 self:correctAdjustments()
end

function NinjaAnimations:jump()
	 if self:isJumping() or self:isAttackFalling() then
			return
	 end

	 self.timer = 0
	 self.currentImage = 'jumping1'
	 self:correctAdjustments()
end

function NinjaAnimations:attack()
	 if self:isAttacking() or self:isAttackFalling() then
			return
	 end

	 if self:isFalling() or self:isJumping() then
			self.currentImage = 'fallingAttack1'
	 else
			self.currentImage = 'attacking1'
	 end

	 self.timer = 0
	 self:correctAdjustments()
end

function NinjaAnimations:duck()
	 self.currentImage = 'ducking'
	 if self.wasDucking == false then
			self.ninja.y = self.ninja.y + 20
			self.wasDucking = true
	 end
end

function NinjaAnimations:hurt()
	 self.currentImage = 'hurt'
	 self:correctAdjustments()
end

function NinjaAnimations:runRight()
	 if self:isMovingRight() or self:isJumping() or self:isAttackFalling() then
			return
	 end

	 self.currentImage = 'running1'
	 self.timer = 0
	 self.direction = RIGHT
	 self:correctAdjustments()
end

function NinjaAnimations:runLeft()
	 if self:isMovingLeft() or self:isJumping() or self:isAttackFalling() then
			return
	 end

	 self.currentImage = 'running1'
	 self.timer = 0
	 self.direction = LEFT
	 self:correctAdjustments()
end

function NinjaAnimations:correctAdjustments()
	 self:stopDucking()
end

function NinjaAnimations:stopDucking()
	 if self.wasDucking then
			self.ninja.y = self.ninja.y - 20
	 end

	 self.wasDucking = false
end
