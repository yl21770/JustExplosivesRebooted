function init()
  if storage.state == nil then
    storage.state = false
  end

  self.interactive = config.getParameter("interactive", true)
  object.setInteractive(self.interactive)

  if config.getParameter("inputNodes") then
    processWireInput()
  end

  self.start = false
  self.timer = config.getParameter("timeToExplode")

  toggleActivation(storage.state)  
end

function onNodeConnectionChange(args)
--Receives input when connected to other wire objects
  processWireInput()
end

function onInputNodeChange(args)
--Receives input from other wire objects
  processWireInput()
end

function onInteraction(args)
--Manual activation
  if not config.getParameter("inputNodes") or not object.isInputNodeConnected(0) then
    storage.state = not storage.state
    --sb.logInfo("Inbound signal detected (Manual)! Bomb activated.")
    toggleActivation(storage.state)
  end
end

function toggleActivation(state)
--Enables bomb state toggling (ON or OFF)
  --object.setAllOutputNodes(state)
  if state then
    animator.setAnimationState("switchState", "on")
    self.start = true
  else
    animator.setAnimationState("switchState", "off")
    self.start = false
    self.timer = config.getParameter("timeToExplode")
  end
end

function processWireInput()
--Enables bomb state toggling via wire (makes manual activation disabled)
  if object.isInputNodeConnected(0) then
    object.setInteractive(false)
    storage.state = object.getInputNodeLevel(0)
    toggleActivation(storage.state)
    --sb.logInfo("Inbound signal detected (Wire)! Bomb activated.")
  elseif self.interactive then
    object.setInteractive(true)
  end
end

function update(dt)
  --Check if countdown has been started
  if self.start then
    --If bomb is activated
    if storage.state then
      --Start timer (default is 6 seconds, modify in .object file)
      if self.timer > 0 then
        --Trigger explosion
        if self.timer <= 1 then
          --Check if projectile specified in .object file is present
          if config.getParameter("firstProjectile") ~= nil then
            world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({ 0.2, 1 }), entity.id())
          end
          --Destroy object
          object.smash()
        end
      end
    --Update Timer
    self.timer = math.max(0, self.timer - dt)
    end
  end
end

function die()
--Triggers other nearby explosives upon explosion
  if config.getParameter("firstProjectile") ~= nil then
    world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({ 0.2, 1 }), entity.id())
  end
end