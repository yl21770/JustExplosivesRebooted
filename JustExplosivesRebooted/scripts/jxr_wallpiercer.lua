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
  object.setInteractive(config.getParameter("interactive" or true))
end

function onNodeConnectionChange(args)
  processWireInput()
end

function onInputNodeChange(args)
  processWireInput()
end

function onInteraction()
  if not config.getParameter("inputNodes") or not object.isInputNodeConnected(0) then
    storage.state = not storage.state
    toggleActivation(storage.state)
  end
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
    object.setInteractive(false)
    storage.state = object.getInputNodeLevel(0)
    toggleActivation(storage.state)
  else
    object.setInteractive(true)
  end
end

function update(dt)
  if self.start then
    if storage.state then
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
      self.anchor = config.getParameter("anchors")[1]
      
      if self.anchor == "top" then
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, 1}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, 2}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, 4}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, 6}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, 8}), entity.id())
      elseif self.anchor == "bottom" then
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, -1}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, -2}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, -4}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, -6}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, -8}), entity.id())
      elseif self.anchor == "left" then
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({-1, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({-2, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({-4, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({-6, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({-8, 0}), entity.id())
      elseif self.anchor == "right" then
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({1, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({2, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({4, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({6, 0}), entity.id())
        world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({8, 0}), entity.id())
      end

      object.smash(true)
    end
  end
end