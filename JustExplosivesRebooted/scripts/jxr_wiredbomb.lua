function init()
  if storage.state == nil then
    storage.state = false
  end

  if config.getParameter("inputNodes") then
    processWireInput()
  end

  self.start = false
  self.timer = config.getParameter("timeToExplode")

  toggleActivation(storage.state)
end

function onNodeConnectionChange(args)
  processWireInput()
end

function onInputNodeChange(args)
  processWireInput()
end

function toggleActivation(state)
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
  if object.isInputNodeConnected(0) then
    storage.state = object.getInputNodeLevel(0)
    toggleActivation(storage.state)
  end
end

function update(dt)
  if storage.state then
    if self.start then
      if self.timer <= 1 then
        die()
      end
    self.timer = self.timer - dt
    end
  end
end

function die()
  if storage.state then
    if config.getParameter("firstProjectile") ~= nil then
      world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0.2, 1}), entity.id())
      
      object.smash(true)
    end
  end
end