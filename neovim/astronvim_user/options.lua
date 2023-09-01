return {
  opt = {
    conceallevel = 2, -- enable conceal
    list = true, -- show whitespace characters
    showtabline = (vim.t.bufs and #vim.t.bufs > 1) and 2 or 1,
    splitkeep = "screen",
    swapfile = false,
    wrap = true, -- soft wrap lines
  },
  g = {
    resession_enabled = true,
  },
}
