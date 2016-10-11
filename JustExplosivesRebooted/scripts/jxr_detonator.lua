function init()
  --Prevent premature explosions
  if storage.state == nil then
    storage.state = false
  end

  self.pos = entity.position()
  self.pos = {self.pos[1] + 0.5, self.pos[2] + 0.5}
  self.detectRange = config.getParameter("detectRange")

  self.timer = 0

  --object.setAllOutputNodes(false)
  toggleActivation(storage.state)
  object.setInteractive(config.getParameter("interactive" or true))
end

function onInteraction()
--Manual activation
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
--Check if players are nearby
  local playerIDs = world.playerQuery(self.pos, self.detectRange)

  if #playerIDs > 0 then
    return true
  end

  return false
end

function update(dt)
  --If bomb is activated
  if storage.state then
    if self.timer > 0 then
      self.timer = self.timer - dt
    else
      local found = entitiesInRange()
      --Detonate only when there are no nearby players
      if not found then
        object.setAllOutputNodes(true)
        die()
      end
      self.timer = 0.2
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