hook.Add("PostDrawOpaqueRenderables", "henke", function()

    for k, v in ipairs(player.GetAll()) do
        local min, max = v:GetCollisionBounds()
        render.DrawWireframeBox(v:GetPos(), Angle(), min, max, Color(255, 0, 0), true)
    end
end)