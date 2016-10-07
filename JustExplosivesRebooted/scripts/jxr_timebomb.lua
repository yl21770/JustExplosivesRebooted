function init()
  if storage.state == nil then
    storage.state = false
  end

  object.setInteractive(config.getParameter("interactive" or true))

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

function onInteraction()
--Manual activation
  if not config.getParameter("inputNodes") or not object.isInputNodeConnected(0) then
    storage.state = not storage.state
    toggleActivation(storage.state)
  end
end

function toggleActivation(state)
--Enables bomb state toggling (ON or OFF)
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
  else
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
          die()
        end
      end
    --Update Timer
    self.timer = self.timer - dt
    end
  end
end

function die()
  if storage.state then
    if config.getParameter("firstProjectile") ~= nil then
      world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0.2, 1}), entity.id())
      
      --Destroy object
      object.smash(true)
    end
  end
end