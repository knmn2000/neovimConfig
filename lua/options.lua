require "nvchad.options"

-- Use PowerShell as the default terminal on Windows
if vim.fn.has "win32" == 1 then
  vim.opt.shell = "powershell"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  vim.opt.shellredir = "| Out-File -Encoding UTF8 %s"
  vim.opt.shellpipe = "| Out-File -Encoding UTF8 %s"
end
