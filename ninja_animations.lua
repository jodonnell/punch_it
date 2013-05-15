require 'class'

NinjaAnimations = class()

RIGHT = 0
LEFT = 1


function NinjaAnimations:init(ninja)
	 self.timer = 0;
	 self.currentImage = 'standing';
	 self.direction = RIGHT;
	 self.ninja = ninja

	 self.wasDucking = false
	 self.wasAttackingLeft = false
	 self.wasAttackFallingLeft = false
	 self.queuedAnimation = 'falling'

	 self.images = { standingRight = love.graphics.newImage("images/ryu_stand_right.png"),
									 standingLeft = love.graphics.newImage("images/ryu_stand_left.png"),
									 running1Left = love.graphics.newImage("images/ryu_running_1_left.png"),
									 running2Left = love.graphics.newImage("images/ryu_running_2_left.png"),
									 running3Left = love.graphics.newImage("images/ryu_running_3_left.png"),
									 running1Right = love.graphics.newImage("images/ryu_running_1_right.png"),
									 running2Right = love.graphics.newImage("images/ryu_running_2_right.png"),
									 running3Right = love.graphics.newImage("images/ryu_running_3_right.png"),
									 duckingLeft = love.graphics.newImage("images/ryu_ducking_left.png"),
									 duckingRight = love.graphics.newImage("images/ryu_ducking_right.png"),
									 jumping1Right = love.graphics.newImage("images/ryu_right_jump_right.png"),
									 jumping2Right = love.graphics.newImage("images/ryu_down_jump_right.png"),
									 jumping3Right = love.graphics.newImage("images/ryu_left_jump_right.png"),
									 jumping4Right = love.graphics.newImage("images/ryu_up_jump_right.png"),
									 jumping1Left = love.graphics.newImage("images/ryu_right_jump_left.png"),
									 jumping2Left = love.graphics.newImage("images/ryu_down_jump_left.png"),
									 jumping3Left = love.graphics.newImage("images/ryu_left_jump_left.png"),
									 jumping4Left = love.graphics.newImage("images/ryu_up_jump_left.png"),
									 attacking1Right = love.graphics.newImage("images/ryu_attack_begin_right.png"),
									 attacking2Right = love.graphics.newImage("images/ryu_attack_middle_right.png"),
									 attacking3Right = love.graphics.newImage("images/ryu_attack_end_right.png"),
									 attacking1Left = love.graphics.newImage("images/ryu_attack_begin_left.png"),
									 attacking2Left = love.graphics.newImage("images/ryu_attack_middle_left.png"),
									 attacking3Left = love.graphics.newImage("images/ryu_attack_end_left.png"),
									 fallingRight = love.graphics.newImage("images/ryu_falling_attack_begin_right.png"),
									 fallingLeft = love.graphics.newImage("images/ryu_falling_attack_begin_left.png"),
									 fallingAttack1Right = love.graphics.newImage("images/ryu_falling_attack_middle_right.png"),
									 fallingAttack2Right = love.graphics.newImage("images/ryu_falling_attack_end_right.png"),
									 fallingAttack1Left = love.graphics.newImage("images/ryu_falling_attack_middle_left.png"),
									 fallingAttack2Left = love.graphics.newImage("images/ryu_falling_attack_end_left.png")
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
	 		if self.direction == LEFT then
				 self.ninja.x = self.ninja.x + 27
	 		end
	 elseif self.timer == 9 then
	 		self.ninja.isAttacking = false
	 		if self.direction == LEFT then
				 self.wasAttackFallingLeft = true
	 		end
			self.currentImage = '' -- to force fall not return early
			self:fall()
	 end

end

function NinjaAnimations:attackingAnimation()
	 if self.timer == 1 then
			self.currentImage = 'attacking1'
	 elseif self.timer == 5 then
	 		self.currentImage = 'attacking2'
			if self.direction == LEFT then
				 self.ninja.x = self.ninja.x - 62
	 		end
	 elseif self.timer == 9 then
	 		self.currentImage = 'attacking3'
	 		if self.direction == LEFT then
	 			 self.ninja.x = self.ninja.x + 24
	 		end
	 elseif self.timer > 12 then
	 		self.ninja.isAttacking = false
	 		if self.direction == LEFT then
				 self.wasAttackingLeft = true
	 		end

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
	 local image = self.currentImage
	 if self.direction == LEFT then
			image = image .. 'Left'
	 else
			image = image .. 'Right'
	 end
	 return self.images[image]
end

function NinjaAnimations:stand()
	 if self:isAttacking() then
			self.queuedAnimation = 'standing'
			return
	 end

	 self.currentImage = 'standing'
	 self:correctAdjustments()
end

function NinjaAnimations:fall()
	 if self:isFalling() or self:isAttackFalling() then
			self.queuedAnimation = 'falling'
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
			if self.direction == LEFT then
				 self.ninja.x = self.ninja.x - 57
	 		end
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

function NinjaAnimations:runRight()
	 if self:isMovingRight() or self:isJumping() or self:isAttackFalling() then
			self.queuedAnimation = 'running1'
			return
	 end

	 self.currentImage = 'running1'
	 self.timer = 0
	 self.direction = RIGHT
	 self:correctAdjustments()
end

function NinjaAnimations:runLeft()
	 if self:isMovingLeft() or self:isJumping() or self:isAttackFalling() then
			self.queuedAnimation = 'running1'
			return
	 end

	 self.currentImage = 'running1'
	 self.timer = 0
	 self.direction = LEFT
	 self:correctAdjustments()
end

function NinjaAnimations:correctAdjustments()
	 self:stopDucking()
	 if self.wasAttackingLeft then
			self.ninja.x = self.ninja.x + 38
			self.wasAttackingLeft = false
	 end
	 
	 if self.wasAttackFallingLeft then
			self.ninja.x = self.ninja.x + 30
			self.wasAttackFallingLeft = false
	 end
			
end

function NinjaAnimations:stopDucking()
	 if self.wasDucking then
			self.ninja.y = self.ninja.y - 20
	 end

	 self.wasDucking = false
end
