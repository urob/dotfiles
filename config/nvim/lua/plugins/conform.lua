vim.api.nvim_command("packadd conform.nvim")

require("conform").setup({
    formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        cs = { "csharpier" },
        just = { "just" },
        lua = { "stylua" },
        -- markdown = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "injected" },
        nix = { "nixfmt"},
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        -- yaml = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "injected" },

        -- TODO: replace prettierd with biome
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettier" }, -- prettierd doesn't support options below
        javascript = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        webc = { "prettier" }, -- prettierd doesn't support options below
    },
})

-- TODO: WIP https://github.com/stevearc/conform.nvim/blob/master/doc/formatter_options.md#injected
-- require("conform").formatters.injected = {
--     options = {
--         lang_to_ext = {
--             webc = "html",
--         },
--     lang_to_formatters = {
--             webc = { "prettier" },
--         },
--     },
-- }

require("conform").formatters = {
    prettier = {
        options = {
            ext_parsers = {
                webc = "html",
            },
        },
    },
    shfmt = {
        prepend_args = { "-s", "-i", "2", "-ci" , "-bn" },
    },

    -- Replaced by yamlfmt
    -- yamlfix = {
    --     env = {
    --         YAMLFIX_WHITELINES = 1,
    --     },
    -- },
}

-- Format command
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
