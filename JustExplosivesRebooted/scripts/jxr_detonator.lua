function init()
  if storage.state == nil then
    storage.state = false
  end

  self.pos = entity.position()
  self.pos = {self.pos[1] + 0.5, self.pos[2] + 0.5}
  self.detectRange = config.getParameter("detectRange")

  self.timer = 0

  toggleActivation(storage.state)
  object.setInteractive(config.getParameter("interactive" or true))
end

function onInteraction()
  if not storage.state then
    storage.state = true
  end
  toggleActivation(storage.state)
  object.setInteractive(false)
end

function toggleActivation(state)
  if state then
    animator.setAnimationState("switchState", "on")
  end
end

function entitiesInRange()
  local playerIDs = world.playerQuery(self.pos, self.detectRange)

  if #playerIDs > 0 then
    return true
  end

  return false
end

function update(dt)
  if storage.state then
    if self.timer > 0 then
      self.timer = self.timer - dt
    else
      local found = entitiesInRange()
      if not found then
        object.setAllOutputNodes(true)
        die()
      end
      self.timer = 0.2
    end
  end
end

function die()
  if storage.state and config.getParameter("firstProjectile") ~= nil then
    world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0.2, 1}), entity.id())

    object.smash(true)
  end
end