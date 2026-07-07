local ok, rm = pcall(require, 'render-markdown')
if not ok then return end

rm.setup({
  render_modes = { 'n', 'c' },
  heading = {
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
  },
  code = {
    sign = false,
    width = 'block',
    border = 'thin',
  },
  bullet = {
    icons = { '●', '○', '◆', '◇' },
  },
  checkbox = {
    unchecked = { icon = '󰄱 ' },
    checked   = { icon = '󰱒 ' },
  },
  link = {
    hyperlink = '󰌹 ',
  },
})
