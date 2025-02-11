-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map({ "i", "v", "s" }, "jk", "<Esc>l", { remap = true, silent = true })
map("t", "<C-j><C-k>", "<C-\\><C-n>", { remap = true, silent = true })
