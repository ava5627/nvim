-- Nix snippets for nixos configuration
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local d = ls.dynamic_node
-- local c = ls.choice_node
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
-- local rep = require("luasnip.extras").rep
-- local line_begin = require("luasnip.extras.expand_conditions").line_begin
return {
    s({ trig = "pln", dscr = "println!", }, fmta(
        "println!(\"<>\"<>);<>",
        { i(1), d(2,
            function(args)
                local nodes = {}
                local n = 1
                for _ in string.gmatch(args[1][1], "{}") do
                    nodes[#nodes + 1] = t(", ")
                    nodes[#nodes + 1] = i(n, "arg" .. n)
                    n = n + 1
                end
                return sn(nil, nodes)
            end,
            { 1 }
        ), i(0) }
    ))
}
