local M = {}

---@class Node
---@field left number
---@field top number
---@field width number
---@field height number
---@field children { left: Node | nil, right: Node | nil }
---@field pane? number
---@field horizontal? boolean
local Node = {}

---@param node Node
function Node.new(node)
  setmetatable(node, { __index = Node })
  return node
end

function Node.print(self)
  print(
    "{ left="
    .. self.left
    .. " top="
    .. self.top
    .. " width="
    .. self.width
    .. " height="
    .. self.height
    .. (self.horizontal ~= nil and (" horizontal=" .. (self.horizontal and "true" or "false")) or "")
    .. (self.pane ~= nil and (" pane=" .. self.pane) or "")
    .. " }"
  )
  if self.children.left ~= nil then
    print("LEFT:")
    self.children.left:print()
  end
  if self.children.right ~= nil then
    print("RIGHT:")
    self.children.right:print()
  end
end

---@param parent? Node
function Node.balance(self, parent, pane_callback)
  local is_left = true
  if parent ~= nil then
    if parent.horizontal == true then
      if self.left ~= parent.left then
        is_left = false
        self.left = math.ceil(parent.width / 2)
      end
      self.width = math.floor(parent.width / 2)
      self.height = parent.height
      self.top = parent.top
    else
      if self.top ~= parent.top then
        is_left = false
        self.top = math.ceil(parent.height / 2)
      end
      self.width = parent.width
      self.height = math.floor(parent.height / 2)
      self.left = parent.left
    end
  end

  if pane_callback ~= nil and self.pane ~= nil and is_left then
    pane_callback(self)
  end

  if self.children.left ~= nil then
    self.children.left:balance(self, pane_callback)
  end
  if self.children.right ~= nil then
    self.children.right:balance(self, pane_callback)
  end
end

---@param sorted_nodes [ Node[], Node[] ]
---@param depth number
local function build(sorted_nodes, depth)
  local axis = (depth % 2) + 1
  local off_axis = (depth + 1) % 2 + 1
  local nodes = sorted_nodes[axis]
  if #nodes == 1 then
    return nodes[1]
  elseif #nodes == 2 then
    ---@type Node
    local node = Node.new({
      left = nodes[1].left,
      top = nodes[1].top,
      width = nodes[2].left - nodes[1].left + nodes[2].width,
      height = nodes[2].top - nodes[1].top + nodes[2].height,
      children = { left = nodes[1], right = nodes[2] },
      horizontal = axis == 1,
    })
    return node
  else
    local median = math.floor(#nodes / 2)

    local left = {}
    left[axis] = { table.unpack(nodes, 1, median) }
    left[off_axis] = {}
    local right = {}
    right[axis] = { table.unpack(nodes, median + 1, #nodes) }
    right[off_axis] = {}

    for _, n in ipairs(sorted_nodes[off_axis]) do
      if axis == 1 then
        if n.left < right[axis][1].left then
          table.insert(left[off_axis], n)
        else
          table.insert(right[off_axis], n)
        end
      else
        if n.top < right[axis][1].top then
          table.insert(left[off_axis], n)
        else
          table.insert(right[off_axis], n)
        end
      end
    end

    local node = Node.new({
      left = nodes[1].left,
      top = nodes[1].top,
      width = nodes[#nodes].left - nodes[1].left + nodes[#nodes].width,
      height = nodes[#nodes].top - nodes[1].top + nodes[#nodes].height,
      children = { left = build(left, depth + 1), right = build(right, depth + 1) },
      horizontal = axis == 1,
    })
    return node
  end
end

---@param nodes Node[]
function M.build_tree(nodes)
  ---@type Node[]
  local copy = {}

  table.sort(nodes, function(a, b)
    if a.left == b.left then
      return a.top < b.top
    end
    return a.left < b.left
  end)

  for i, node in ipairs(nodes) do
    copy[i] = node
  end

  table.sort(copy, function(a, b)
    if a.top == b.top then
      return a.top < b.top
    end
    return a.top < b.top
  end)

  local sorted = { nodes, copy }
  return build(sorted, 0)
end

-- ---@type Node[]
-- local panes = {
--   Node.new({
--     top = 256,
--     left = 300,
--     width = 213,
--     height = 256,
--     children = { nil, nil },
--     pane = 2,
--   }),
--   Node.new({
--     top = 0,
--     left = 300,
--     width = 213,
--     height = 256,
--     children = { nil, nil },
--     pane = 1,
--   }),
--   Node.new({
--     top = 0,
--     left = 0,
--     width = 300,
--     height = 513,
--     children = { nil, nil },
--     pane = 0,
--   }),
-- }
--
-- local tree = Node.build_tree(panes)
-- tree:print()
-- tree:balance()
-- print()
-- tree:print()

M.Node = Node

return M
