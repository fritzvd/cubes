local Cube = {}
Cube.__index = Cube

shader = love.graphics.newShader("shader.fs")

function Cube.create (x, y, z, w, h, d)
  local cube = {}
  setmetatable(cube, Cube)
  cube.color = 0
  cube.nodes = {
    {     x,    y ,     z },
    {     x,    y , z + d },
    {     x, y + h,     z },
    {     x, y + h, z + d },
    { x + w,     y,     z },
    { x + w,     y, z + d },
    { x + w, y + h,     z },
    { x + w, y + h, z + d }
  }
  cube.edges = {
    {1,2}, {2,4}, {4,3}, {3,1},
    {5,6}, {6,8}, {8,7}, {7,5},
    {1,5}, {2,6}, {3,7}, {4,8}
  }

  cube.faces = {
    {1, 2, 4, 3}, {2, 1, 5, 6},
    {1, 3, 7, 5}, {4, 2, 6, 8},
    {6, 5, 7, 8}, {3, 4, 8, 7}
  }
  return cube
end

function Cube:draw ()
  -- love.graphics.setColor(self.color)
  self:drawCube()
  -- self:drawEdgesNodes()
end

function Cube:drawCube ()
  love.graphics.setShader(shader)
  for k,v in pairs(self.faces) do
    love.graphics.polygon('fill',
      self.nodes[v[1]][1], self.nodes[v[1]][2],
      self.nodes[v[2]][1], self.nodes[v[2]][2],
      self.nodes[v[3]][1], self.nodes[v[3]][2],
      self.nodes[v[4]][1], self.nodes[v[4]][2]
    )
  end
  love.graphics.setShader()
end

function Cube:drawEdgesNodes ()
  love.graphics.setColor(self.color)
  for k,v in pairs(self.nodes) do
    love.graphics.circle('fill', v[1], v[2], 8, 100)
  end
  for e,v in pairs(self.edges) do
    n0 = v[1]
    n1 = v[2]
    local node0 = self.nodes[n0]
    local node1 = self.nodes[n1]

    love.graphics.line(node0[1], node0[2], node1[1], node1[2])
  end
end

function Cube:setColor (color)
  self.color = color
end

function Cube:rotate3D (theta, node1, node2)
  sin_t = math.sin(theta)
  cos_t = math.cos(theta)

  for k,node in pairs(self.nodes) do
    local x = node[node1]
    local y = node[node2]
    node[node1] = x * cos_t - y * sin_t
    node[node2] = y * cos_t + x * sin_t
  end
end

function Cube:rotateZ3D (theta)
  self:rotate3D(theta, 1, 2)
end

function Cube:rotateX3D (theta)
  self:rotate3D(theta, 2, 3)
end

function Cube:rotateY3D (theta)
  self:rotate3D(theta, 1, 3)
end

return Cube
