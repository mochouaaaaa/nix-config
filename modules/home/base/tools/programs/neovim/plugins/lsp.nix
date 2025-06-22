{ lib, pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-lspconfig;
      config = ''
        local common = require("plugins.lsp.lang.common")

        local lspconfig = require("lspconfig")

        local lang_dir = vim.fn.stdpath("config") .. "/lua/plugins/lsp/lang"

        local function get_lang_servers()
            local servers = {}
            local scan = vim.fn.globpath(lang_dir, "*", false, true)
            for _, file in ipairs(scan) do
                if vim.fn.isdirectory(file) == 1 then
                    local name = file:match("([^/]+)$")
                    if name then
                        table.insert(servers, name)
                    end
                end
            end
            return servers
        end

        for _, server in ipairs(get_lang_servers()) do
            local server_settings = "plugins.lsp.lang." .. server .. ".settings"
            local server_config = "plugins.lsp.lang." .. server .. ".config"

            local settings = {}
            if pcall(require, server_settings) then
                settings = require(server_settings)
            end

            local config = {
                capabilities = common.make_capabilities(),
                on_attach = common.setup,
                settings = settings,
            }

            if pcall(require, server_config) then
                local extra = require(server_config).extra
                local on_attach = require(server_config).on_attach

                if extra and type(extra) == "function" then
                    config = vim.tbl_extend("force", config, extra(config))
                end

                if on_attach and type(on_attach) == "function" then
                    local default_on_attach = config.on_attach
                    config.on_attach = function(client, bufnr)
                        default_on_attach(client, bufnr)
                        on_attach(client, bufnr)
                    end
                end
            end

            lspconfig[server].setup(config)
        end
      '';
    }
    {
      plugin = typescript-tools-nvim;
      config = ''
        local common = require("plugins.lsp.lang.common")

        local api = require("typescript-tools.api")
        return {
            on_attach = common.setup,
            handlers = {
                ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
                    -- Ignore 'This may be converted to an async function' diagnostics.
                    { 80006, 7044 }
                ),
            },

            settings = {
                separate_diagnostic_server = true,
                publish_diagnostic_on = "insert_leave",
                tsserver = {
                    diagnosticOptions = {
                        semantic = false, -- 关闭语义诊断
                        suggestion = true, -- 可以打开建议
                        syntactic = true, -- 保留语法检查
                    },
                },
                tsserver_plugins = {
                    "@styled/typescript-styled-plugin",
                },
            },
        }

      '';
    }
  ];

}
