function init()
  self.pos = entity.position()
end

function die()
  liquidType = config.getParameter("liquidType")
  
  if liquidType ~= nil and config.getParameter("firstProjectile") ~= nil then
    world.spawnProjectile(config.getParameter("firstProjectile"), object.toAbsolutePosition({0, 0}), entity.id())
    world.spawnLiquid(self.pos, liquidType, 25)
    object.smash()
  end
end