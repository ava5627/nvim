-- Nix snippets for nixos configuration
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local d = ls.dynamic_node
local c = ls.choice_node
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.conditions.expand").line_begin
local events = require("luasnip.util.events")
return {
    s({ trig = "module", dscr = "Module Template", }, fmta(
        [[
            {
              config,
              lib,
              pkgs,
              ...
            }:
            with lib;
            with lib.my; let
              cfg = config.modules.<>;
            in {
              options.modules.<>.enable = mkBool true "<>";
              config = mkIf cfg.enable {
                <>
              };
            }
        ]],
        { i(1, "name"), rep(1), i(2, "description"), i(0) }
    ), { condition = line_begin }),
    s({ trig = "template", dscr = "Basic Template" }, fmta(
        [[
            {
              pkgs,
              inputs,
              lib,
              ...
            }:
            {
              <>
            }
        ]],
        { i(0) }
    )),
    s({ trig = "shell", dscr = "Shell Template" }, fmta(
        [[
            {pkgs ? import <<nixpkgs>> {}}:
            pkgs.mkShell {
              buildInputs = with pkgs; [
                <>
              ];
            }
        ]],
        { i(0) }
    )),
    s({ trig = "envpkgs", dscr = "Environment Packages" }, fmta(
        [[
            environment.systemPackages = with pkgs; [
              <>
            ];
        ]],
        { i(0) }
    ), { condition = line_begin }),
    s({ trig = "=;", snippetType = "autosnippet", dscr = "Auto Semicolon" }, fmta(
        [[
            = <>
        ]],
        { c(1, {
            sn(nil, { t({ "{", "\t" }), i(1), t({ "", "};" }) }),
            sn(nil, { t({ "[", "\t" }), i(1), t({ "", "];" }) }),
            sn(nil, { t("("), i(1), t(")") }),
        }) }
    )),
    s({ trig = "ffg", dscr = "Auto Fetch Git", snippetType = "autosnippet" },
        fmta(
            [[
            src = fetchFromGitHub {
              owner = "<>";
              repo = "<>";
              rev = "<>";
              sha256 = "<>";
            };<>
        ]],
            {
                i(1, "owner"),
                i(2, "repo"),
                i(3, "rev"),
                i(4, "HASH"),
                i(0)
            }
        ), {
            callbacks = {
                [4] = {
                    [events.leave] = function(node, _)
                        if node:get_text()[1] ~= "HASH" then
                            return
                        end
                        local owner = node.parent.snippet.nodes[2]:get_text()[1]
                        local repo = node.parent.snippet.nodes[4]:get_text()[1]
                        local rev = node.parent.snippet.nodes[6]:get_text()[1]
                        local fetch_hash_cmd = string.format(
                            "nix-prefetch-git --quiet --url https://github.com/%s/%s --rev %s",
                            owner, repo, rev
                        )
                        local fetch_hash_list = vim.split(fetch_hash_cmd, " ", { plain = true })
                        local output = vim.system(fetch_hash_list, { text = true }):wait()
                        if output.code ~= 0 then
                            vim.notify("Failed to fetch hash: " .. output.stderr, vim.log.levels.ERROR)
                            return
                        end
                        local json = vim.fn.json_decode(output.stdout)
                        local hash = json["sha256"]
                        node.parent.snippet.nodes[8]:set_text({ hash })
                    end,
                },
            },

        }
    ),
}
