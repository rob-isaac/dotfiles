local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local c = ls.choice_node
local i = ls.insert_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "fori",
    fmt(
      [[
  for ({} i = {}; i < {}; ++i) {{
    {}
}}
  ]],
      {
        c(1, {
          t("U64"),
          t("I64"),
          i(nil),
        }),
        i(2, "0"),
        c(3, {
          sn(nil, { t("ARRAY_LEN("), i(1), t(")") }),
          sn(nil, { i(1), t(".size()") }),
          i(nil),
        }),
        i(0),
      }
    )
  ),
  s(
    "main",
    fmt(
      [[int main(int argc, char** argv) {{
  {}
  return 0;
}}
  ]],
      {
        i(0),
      }
    )
  ),
  s("#o", {
    t("#pragma once"),
  }),
  s("#inc", fmt([[#include "{}"]], { i(0) })),
  s("#inc<", fmt([[#include <{}>]], { i(0) })),
  s(
    "if",
    fmt(
      [[if ({}) {{
  {}
}}]],
      { i(1), i(0) }
    )
  ),
  s(
    "do",
    fmt(
      [[do {{
  {}
}} while ({})]],
      { i(0), i(1, "false") }
    )
  ),
  s(
    "#def",
    fmt(
      [[#define {} \
  {}
]],
      { i(1, "MACRO"), i(0) }
    )
  ),
}
