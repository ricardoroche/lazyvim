return {

  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.compat", lazy = true },
    opts = {
      sources = {
        default = { "obsidian", "obsidian_new", "obsidian_tags" },
        providers = {
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
          },
          obsidian_new = {
            name = "obsidian_new",
            module = "blink.compat.source",
          },
          obsidian_tags = {
            name = "obsidian_tags",
            module = "blink.compat.source",
          },
        },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      checkbox = {
        enabled = true,
      },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    opts = {
      new_notes_location = "1_inbox",
      preferred_link_style = "wiki",
      disable_frontmatter = true,
      use_advanced_uri = true,
      sort_by = "modified",
      sort_reversed = "true",
      open_notes_in = "current",

      workspaces = {
        {
          name = "exocortex",
          path = "~/vaults/exocortex/",
        },
      },
      templates = {
        folder = "6_templates",
      },
      attachments = {
        img_folder = "8_attachments/img",
      },
      picker = {
        name = "fzf-lua",
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },
      completion = {
        nvim_cmp = true,
      },
      ui = {
        enable = false,
      },

      mappings = {
        ["<leader>on"] = {
          action = ":ObsidianNew<CR>",
          opts = {
            buffer = true,
            desc = "Create a new Obsidian note.",
          },
        },
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle check box
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- Functions

      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / ("1_inbox/" .. tostring(spec.id))
        return path:with_suffix(".md")
      end,

      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        local name = ""
        if title ~= nil then
          name = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          name = tostring(os.time()) .. "-"
          for _ = 1, 4 do
            name = name .. string.char(math.random(65, 90))
          end
        end
        return tostring(name)
      end,

      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
    },
    -- config = function(_, opts)
    --   require("obsidian").setup(opts)
    -- end,
  },
}
