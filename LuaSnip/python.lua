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
local function cp(index) return f(function(_, snip) return snip.captures[index] end) end

local function postfix(func)
    return s(
        {
            trig = "(%w+)%." .. func,
            trigEngine = "pattern",
            dscr = "Auto " .. func,
            snippetType = "autosnippet",
        },
        fmta(func .. [[(<>)]], { cp(1) })
    )
end

return {
    postfix("len"),
    postfix("reversed"),
    s(
        {
            trig = "for (.+) in (.+)enum",
            trigEngine = "pattern",
            dscr = "Auto Enumerate",
            snippetType = "autosnippet",
        },
        fmta([[
            for <>, <> in enumerate(<>):<>
        ]], {
            cp(1), i(1, "i"), f(function(_, snip) return snip.captures[2]:match("(.+):") or snip.captures[2] end), i(0)
        })
    ),
    s(
        { trig = "([^f])(\"[^\"]*%{.)", trigEngine = "pattern", snippetType = "autosnippet" },
        fmta([[<>f<>]], { cp(1), cp(2) })
    ),
    s( { trig = "ehome", dscr = "Expand Home" }, { t("os.path.expanduser(\"~\")") }),
}
