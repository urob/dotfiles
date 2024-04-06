vim.api.nvim_command("packadd conform.nvim")

require("conform").setup({
    formatters_by_ft = {
        cs = { "csharpier" },
        css = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        sh = { "shfmt" },
        lua = { "stylua" },
        markdown = { { "prettierd", "prettier" } },
        nix = { "alejandra" },
        python = { "ruff_format" },
        scss = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
    },
})

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
