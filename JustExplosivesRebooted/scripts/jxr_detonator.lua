function init()
--Prevent premature explosions
  if storage.state == nil then
    storage.state = false
  end

  self.detectEntityTypes = config.getParameter("detectEntityTypes")
  local pos = object.position()
  self.detectArea = {
      {pos[1] + detectArea[1][1], pos[2] + detectArea[1][2]},
      {pos[1] + detectArea[1][1], pos[2] + detectArea[1][2]}
  }

  object.setInteractive(config.getParameter("interactive" or true))
  object.setAllOutputNodes(false)
  toggleActivation(storage.state)
  self.triggerTimer = 0  
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
    object.setAllOutputNodes(true)
    animator.setAnimationState("switchState", "on")
    self.triggerTimer = config.getParameter("detectDuration")
    sb.logInfo("Detonator triggered!")
  end
end

function playersInRange()
--Check if players are nearby
  local count = 0
  if storage.detectPlayer then
    local playerIDs = world.playerQuery(self.pos, 10)
    count = count + #playerIDs
  end
  return count > 0
end

function update(dt)
  --If bomb is activated
  if storage.state then
    if self.triggerTimer > 0 then
      self.triggerTimer - dt
    elseif self.trigger <= 0 then
      local playersFound = playersInRange()
      --Detonate only when there are no nearby players
      if not playersFound then
        die()
        --Destroy object
        object.smash()
      end
    end
  end
end

function die()
--Triggers other nearby explosives upon explosion
  if config.getParameter("firstProjectile") ~= nil then
    world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({ 0.2, 1 }), entity.id())
  end
end