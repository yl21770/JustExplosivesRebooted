function init()
--Prevent premature explosions
  if storage.state == nil then
    storage.state = false
  end

  self.detectEntityTypes = config.getParameter("detectEntityTypes")
  self.pos = entity.position()
  self.pos = {self.pos[1] + 0.5, self.pos[2] + 0.5}
  self.detectRange = config.getParameter("detectRange")

  object.setInteractive(config.getParameter("interactive" or true))
  object.setAllOutputNodes(false)
  toggleActivation(storage.state)
  self.timer = 0
end

function onInteraction()
--Manual activation
  if storage.state then
    storage.state = false
  else
    storage.state = true
  end
  toggleActivation(storage.state)
end

function toggleActivation(state)
--Enables bomb state toggling (ON or OFF)
  --object.setAllOutputNodes(state)
  if state then
    animator.setAnimationState("switchState", "on")
    self.triggerTimer = config.getParameter("detectDuration")
  end
end

function entitiesInRange()
--Check if players are nearby
  local count = 0

  local playerIDs = world.playerQuery(self.pos, self.detectRange)
  count = count + #playerIDs

  return count > 0
end

function update(dt)
  --If bomb is activated
  if storage.state then
    if self.timer > 0 then
      self.timer = self.timer - dt
    else
      local playersFound = entitiesInRange()
      --Detonate only when there are no nearby players
      if not playersFound then
        object.setAllOutputNodes(true)
        die()
        --Destroy object
        object.smash()
      end
      self.timer = 0.4
    end
  end
end

function die()
--Triggers other nearby explosives upon explosion
  if config.getParameter("firstProjectile") ~= nil then
    world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0.2, 1}), entity.id())
  end
end