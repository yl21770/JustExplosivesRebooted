function init()
  if storage.state == nil then
    storage.state = false
  end

  self.pos = entity.position()
  self.pos = {self.pos[1] + 0.5, self.pos[2] + 0.5}
  self.detectRange = config.getParameter("detectRange")

  self.timer = 6

  toggleActivation(storage.state)
  object.setInteractive(config.getParameter("interactive" or true))
end

function onInteraction()
  if storage.state then
    storage.state = false
  else
    storage.state = true
  end
  toggleActivation(storage.state)
end

function toggleActivation(state)
  if state then
    animator.setAnimationState("switchState", "on")
  else
    animator.setAnimationState("switchState", "off")
  end
end

function entitiesInRange()
  local count = 0

  local playerIDs = world.playerQuery(self.pos, self.detectRange)
  local npcIDs = world.npcQuery(self.pos, self.detectRange)
  local monsterIDs = world.monsterQuery(self.pos, self.detectRange)
  count = count + #playerIDs + #npcIDs + #monsterIDs

  if count > 0 then
    return true
  end
  
  return false
end

function update(dt)
  if storage.state then
    if self.timer > 0 then
      self.timer = self.timer - dt
    else
      local playersFound = entitiesInRange()
      if playersFound then
        die()
      end
    end
  else
    self.timer = 6
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