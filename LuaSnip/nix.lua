-- Nix snippets for nixos configuration
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin
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
}
