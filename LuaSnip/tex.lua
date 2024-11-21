-- Nix snippets for nixos configuration
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
-- local rep = require("luasnip.extras").rep
-- local line_begin = require("luasnip.extras.expand_conditions").line_begin
local function cp(index) return f(function(_, snip) return snip.captures[index] end) end

local tex = {}
tex.in_math = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
    return not tex.in_math()
end
tex.in_comment = function()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end
tex.env = function(name)
    local x, y = vim.fn["vimtex#env#is_inside"](name)
    return x ~= "0" and y ~= "0"
end

return {
    s({ trig = "date", dscr = "Insert date" }, { t(os.date("%B %d, %Y")) }),
    s({ trig = "time", dscr = "Insert time" }, { t(os.date("%H:%M:%S")) }),
    s({ trig = "template", dscr = "Basic template" }, fmta(
        [[
            \documentclass{<>}

            \usepackage[utf8]{inputenc}
            \usepackage{amsmath}
            \usepackage{graphicx}

            \title{<>}
            \author{Ava Harris}
            \date{<>}

            \begin{document}

            \maketitle

            <>

            \end{document}
        ]],
        { i(1, "article"), i(2, "Title"), t(os.date("%B %d, %Y")), i(0) }
    )),
    s(
        { trig = "dm", dscr = "Display math" },
        fmta([[
            \[
                <>
            \]
        ]], { i(0) })
    ),
    s(
        { trig = "//", dscr = "Fraction", snippetType = "autosnippet" },
        fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(0) }),
        { condition = tex.in_math }
    ),
    s(
        {
            trig = "(((\\d+)|(\\d*)(\\\\)?([A-Za-z]+))((\\^|_)(\\{\\d+\\}|\\d))*)/",
            trigEngine = "ecma",
            dscr = "Fraction single",
            snippetType = "autosnippet"
        },
        fmta("\\frac{<>}{<>}<>", { cp(1), i(1), i(0) }),
        { condition = tex.in_math }
    ),
    s(
        {
            trig = "^.*%)/",
            trigEngine = "pattern",
            dscr = "Fraction Paren",
            snippetType = "autosnippet",
        },
        { f(
            function(_, snip)
                local depth = 0
                local stripped = snip.trigger
                local j = #stripped - 1
                while j > 0 do
                    if stripped:sub(j, j) == ")" then
                        depth = depth + 1
                    elseif stripped:sub(j, j) == "(" then
                        depth = depth - 1
                    end
                    if depth == 0 then
                        break
                    end
                    j = j - 1
                end
                return stripped:sub(1, j - 1) .. "\\frac{" .. stripped:sub(j + 1, #stripped - 2) .. "}"
            end
        ), t("{"), i(1), t("}"), i(0) },
        { condition = tex.in_math }
    ),
    s(
        {
            trig = "([%^_])([^{ ])",
            trigEngine = "pattern",
            wordTrig = false,
            dscr = "Super/sub script",
            snippetType = "autosnippet"
        },
        { cp(1), t("{"), cp(2), i(1), t("}"), i(0) }
    ),
    s(
        {
            trig = "img",
            dscr = "Add image",
        },
        fmta(
            "<>\\includegraphics<>{<>}<>",
            {
                d(3,
                    function(args)
                        if args[1][1] == "[width=\\textwidth]" then
                            return sn(nil, { t("\\noindent") })
                        end
                        return sn(nil, { t("") })
                    end,
                    { 1 }
                ),
                c(1, {
                    t("[width=\\textwidth]"),
                    sn(nil, { t("[width="), i(1), t("]") }),
                    t("")
                }),
                i(2), i(0)
            }
        )
    ),
    s(
        { trig = "\\sum", dscr = "Sum", },
        fmta("\\sum_{<>}^{<>}<>", { i(1), i(2), i(0) }),
        { condition = tex.in_math }
    ),
    s(
        { trig = "\\prod", dscr = "Product", },
        fmta("\\prod_{<>}^{<>}<>", { i(1), i(2), i(0) }),
        { condition = tex.in_math }
    ),
    s(
        { trig = "\\lim", dscr = "Limit", },
        fmta("\\lim_{<> \\to <>}<>", { i(1, "x"), i(2, "\\infty"), i(0) }),
        { condition = tex.in_math }
    ),
    s(
        { trig = "sq", dscr = "Square root", },
        fmta("\\sqrt{<>}<>", { i(1), i(0) }),
        { condition = tex.in_math }
    ),
    s(
        { trig = "([A-Za-z])#([a-zA-Z0-9])", dscr = "Index", trigEngine = "pattern", snippetType = "autosnippet" },
        fmta("<>^{(<>)}<>", { cp(1), cp(2), i(0) }),
        { condition = tex.in_math }
    ),
}
