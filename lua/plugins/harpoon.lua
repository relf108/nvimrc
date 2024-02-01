return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon.setup({
        global_settings = {
          save_on_toggle = true,
          save_on_change = true,
        },
      })
      vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader>o", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<leader>i", function() harpoon:list():next() end)
    end,
  }
}
