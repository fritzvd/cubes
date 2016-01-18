local Cube = require 'cube'

local nodes = {
  {-100, -100, -100}, -- 1
  {-100, -100,  100}, -- 2
  {-100,  100, -100}, -- 3
  {-100,  100,  100}, -- 4
  { 100, -100, -100}, -- 5
  { 100, -100,  100}, -- 6
  { 100,  100, -100}, -- 7
  { 100,  100,  100}, -- 8
}

local edges = {
  {0, 1}, -- 0
  {1, 3}, -- 1
  {3, 2}, -- 2
  {2, 0}, -- 3
  {4, 5}, -- 4
  {5, 7}, -- 5
  {7, 6}, -- 6
  {6, 4}, -- 7
  {0, 4}, -- 8
  {2, 6}, -- 9
  {1, 5},  -- 10
  {3, 7}  -- 11
}

-- [0, 1, 3, 2], [1, 0, 4, 5],
-- [0, 2, 6, 4], [3, 1, 5, 7],
-- [5, 4, 6, 7], [2, 3, 7, 6]

function getFaces ()
  return {
    { edges[0], edges[1], edges[2], edges[3] },
    { edges[8], edges[7], edges[9], edges[3] },
    { edges[4], edges[5], edges[6], edges[7] },
    { edges[10], edges[1], edges[11], edges[5] },
    { edges[10], edges[0], edges[8], edges[4] },
    { edges[11], edges[6], edges[9], edges[2] },
  }
end

nodeColor, edgeColor, nodeRadius = nil, nil, nil

function rotate3D (theta, node1, node2)
  sin_t = math.sin(theta)
  cos_t = math.cos(theta)

  for k,node in pairs(nodes) do
    local x = node[node1]
    local y = node[node2]
    node[node1] = x * cos_t - y * sin_t
    node[node2] = y * cos_t + x * sin_t
  end
end

function rotateZ3D (theta)
  rotate3D(theta, 1, 2)
end

function rotateY3D (theta)
  rotate3D(theta, 2, 3)
end

function rotateX3D (theta)
  rotate3D(theta, 1, 3)
end

mouseX, mouseY = 0, 0;

function love.load()
  love.graphics.setBackgroundColor(0, 0, 0)

  alpha = 0
  nodeColor = {40, 168, 107}
  edgeColor = {34, 68, 204}
  nodeRadius = 8

  width, height, mode = love.window.getMode()
  framerate = 60
  cube = Cube.create(-100, -100, -200, 30, 130, 30)
  cube:setColor(nodeColor)
end

function love.update()
  local prevMouseX = mouseX
  local prevMouseY = mouseY
  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()
  -- rotateZ3D(-0.01)
  rotateX3D((prevMouseX - mouseX) / framerate)
  rotateY3D((prevMouseY - mouseY) / framerate)

  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()
  -- cube:rotateZ3D(-0.01)
  cube:rotateY3D((prevMouseX - mouseX) / framerate)
  cube:rotateX3D((prevMouseY - mouseY) / framerate)

  if love.keyboard.isDown('escape') then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.translate(width / 2, height / 2)
  love.graphics.setColor(nodeColor)
  for k,v in pairs(nodes) do
    love.graphics.circle('fill', v[1], v[2], nodeRadius, 100)
  end
  for e,v in pairs(edges) do
    love.graphics.setColor(edgeColor)
    n0 = v[1];
    n1 = v[2];
    node0 = nodes[n0 + 1];
    node1 = nodes[n1 + 1];
    love.graphics.line(node0[1], node0[2], node1[1], node1[2]);
  end

  cube:draw()
end
