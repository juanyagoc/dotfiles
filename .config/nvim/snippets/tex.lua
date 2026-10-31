---@diagnostic disable: undefined-global
-- ~/.config/nvim/luasnippets/tex.lua
-- ----------------------------------------------------------------------------
-- Snippets de LuaSnip para tomar apuntes de matemáticas en LaTeX (con vimtex).
--
-- Inspirado en el flujo de Gilles Castel y en las configuraciones de la
-- comunidad (evesdropper, etc.), pero escrito para el loader de Lua de LuaSnip:
--   * el nombre del archivo (tex.lua) es el filetype al que se aplica;
--   * el loader inyecta s, t, i, f, d, sn, fmta, rep... como globales;
--   * el archivo devuelve DOS tablas: snippets normales y autosnippets.
--
-- Convenciones LaTeX:
--   * matemáticas en línea:  \( ... \)   (no $ ... $)
--   * matemáticas en bloque: \[ ... \]   (no $$ ... $$)
--   * align*/gather* en lugar de eqnarray; \varepsilon, \varphi, \lvert...
--   * compatible con pdflatex (solo amsmath/amssymb/mathtools)
--
-- Reglas de diseño:
--   * Los AUTOSNIPPETS matemáticos solo se expanden dentro de una zona
--     matemática (vimtex) y nunca justo después de una "\" (para no romper
--     \sin, \hbar, \cdot... escritos a mano).
--   * Los entornos (teo, lem, ali...) son snippets NORMALES (se expanden con
--     tu tecla de expansión), porque un autosnippet saltaría al escribir
--     palabras como "alinear" o "demostración" al principio de línea.
-- ----------------------------------------------------------------------------

local snippets, autosnippets = {}, {}

-- ----------------------------------------------------------------------------
-- Condiciones (vimtex)
-- ----------------------------------------------------------------------------
local function truthy(v)
  return v == 1 or v == true
end

local function in_mathzone()
  local ok, res = pcall(vim.fn["vimtex#syntax#in_mathzone"])
  return ok and truthy(res)
end

local function in_comment()
  local ok, res = pcall(vim.fn["vimtex#syntax#in_comment"])
  return ok and truthy(res)
end

local function in_text()
  return not in_mathzone() and not in_comment()
end

local function in_env(name)
  local ok, res = pcall(vim.fn["vimtex#env#is_inside"], name)
  return ok and type(res) == "table" and res[1] > 0 and res[2] > 0
end

local function in_align()
  -- vimtex usa el nombre como regex, por eso el asterisco va escapado
  return in_env("align") or in_env("align\\*") or in_env("aligned") or in_env("split")
end

local function in_list()
  return in_env("itemize") or in_env("enumerate") or in_env("description")
end

-- Las condiciones reciben (line_to_cursor, matched_trigger, captures)
local function line_begin(line_to_cursor, matched_trigger)
  return line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^%s*$") ~= nil
end

local function not_after_backslash(line_to_cursor, matched_trigger)
  return not line_to_cursor:sub(1, -(#matched_trigger + 1)):match("\\$")
end

local function all(...)
  local checks = { ... }
  return function(...)
    for _, check in ipairs(checks) do
      if not check(...) then
        return false
      end
    end
    return true
  end
end

local math_cond = all(not_after_backslash, in_mathzone)
local text_cond = all(not_after_backslash, in_text)

-- ----------------------------------------------------------------------------
-- Utilidades
-- ----------------------------------------------------------------------------

-- Registra un snippet. `extra` admite cualquier campo del contexto de LuaSnip
-- (wordTrig, priority, trigEngine...) y además `condition`, que se combina
-- con la condición base con un AND.
local function add(is_auto, base_cond, trig, nodes, extra)
  extra = vim.tbl_extend("force", {}, extra or {})

  local cond = base_cond
  if extra.condition then
    cond = base_cond and all(extra.condition, base_cond) or extra.condition
  end
  extra.condition = nil

  local ctx = vim.tbl_extend("force", {
    trig = trig,
    wordTrig = trig:match("^%w") ~= nil, -- los triggers con símbolos se expanden en cualquier sitio
    priority = 1000 + #trig, -- a igualdad de terminación gana el trigger más largo (-> vs -->)
  }, extra)
  if is_auto then
    ctx.snippetType = "autosnippet"
  end

  table.insert(is_auto and autosnippets or snippets, s(ctx, nodes, { condition = cond }))
end

local function math_auto(trig, nodes, extra) add(true, math_cond, trig, nodes, extra) end
local function text_auto(trig, nodes, extra) add(true, text_cond, trig, nodes, extra) end
local function math_snip(trig, nodes, extra) add(false, in_mathzone, trig, nodes, extra) end
local function text_snip(trig, nodes, extra) add(false, in_text, trig, nodes, extra) end

-- Contexto para triggers que son patrones de Lua (con capturas)
local function pattern(extra)
  return vim.tbl_extend("force", { trigEngine = "pattern", wordTrig = false }, extra or {})
end

-- Nodo de función que devuelve la captura n del trigger
local function capture(n)
  return f(function(_, snip)
    return snip.captures[n]
  end)
end

-- Inserta la selección visual si existe (requiere store_selection_keys).
local function get_visual(_, parent)
  local selection = parent.snippet.env.LS_SELECT_RAW
  if selection and #selection > 0 then
    return sn(nil, i(1, selection))
  end
  return sn(nil, i(1))
end

-- \cmd{<selección o vacío>}
local function wrap(cmd)
  return fmta("\\" .. cmd .. "{<>}<>", { d(1, get_visual), i(0) })
end

-- ----------------------------------------------------------------------------
-- 1. TEXTO: delimitadores matemáticos y formato
-- ----------------------------------------------------------------------------

-- mk -> \( ... \)     dm -> \[ ... \]
text_auto("mk", fmta("\\(<>\\)<>", { d(1, get_visual), i(0) }))
text_auto("dm", fmta("\\[\n\t<>\n\\]<>", { d(1, get_visual), i(0) }))

text_auto("tbf", wrap("textbf"))
text_auto("tit", wrap("textit"))
text_auto("tem", wrap("emph"))

-- ----------------------------------------------------------------------------
-- 2. TEXTO: estructura, entornos y listas (snippets normales)
-- ----------------------------------------------------------------------------

text_snip("sec", fmta("\\section{<>}\n<>", { i(1), i(0) }))
text_snip("sub", fmta("\\subsection{<>}\n<>", { i(1), i(0) }))
text_snip("ssub", fmta("\\subsubsection{<>}\n<>", { i(1), i(0) }))

text_snip("beg", fmta("\\begin{<>}\n\t<>\n\\end{<>}", { i(1), i(0), rep(1) }))

local function env_nodes(name, is_list)
  local body = is_list and "\\item <>" or "<>"
  return fmta("\\begin{" .. name .. "}\n\t" .. body .. "\n\\end{" .. name .. "}", { i(0) })
end

-- { trigger, entorno, ¿lista? } -- ajusta los nombres a los que defina tu preámbulo
local environments = {
  { "teo", "theorem" },
  { "lem", "lemma" },
  { "prop", "proposition" },
  { "cor", "corollary" },
  { "def", "definition" },
  { "ejm", "example" },
  { "obs", "remark" },
  { "dem", "proof" },
  { "ali", "align*" },
  { "alin", "align" },
  { "gat", "gather*" },
  { "enum", "enumerate", true },
  { "item", "itemize", true },
  { "desc", "description", true },
}
for _, e in ipairs(environments) do
  text_snip(e[1], env_nodes(e[2], e[3]))
end

-- Ecuación numerada y referenciable
text_snip("eqn", fmta("\\begin{equation}\n\t<>\n\t\\label{eq:<>}\n\\end{equation}", { i(1), i(0) }))

-- \item automático al empezar línea dentro de una lista
text_auto("ii", t("\\item "), { condition = function(...)
  return line_begin(...) and in_list()
end })

-- Código con minted
text_snip("mint", fmta("\\begin{minted}{<>}\n<>\n\\end{minted}", { i(1, "cpp"), i(0) }))

-- Plantilla de documento (si tu juan.sty ya define esto, quita el bloque de teoremas)
text_snip("tpl", fmta([[
\documentclass[a4paper,11pt]{article}

\usepackage[T1]{fontenc}
\usepackage[spanish]{babel}
\usepackage{amsmath, amssymb, amsthm, mathtools}
\usepackage{enumitem}
\usepackage{hyperref}

\theoremstyle{plain}
\newtheorem{theorem}{Teorema}[section]
\newtheorem{lemma}[theorem]{Lema}
\newtheorem{proposition}[theorem]{Proposición}
\newtheorem{corollary}[theorem]{Corolario}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definición}
\newtheorem{example}[theorem]{Ejemplo}
\theoremstyle{remark}
\newtheorem*{remark}{Observación}

\title{<>}
\author{<>}
\date{\today}

\begin{document}
\maketitle

<>

\end{document}
]], { i(1, "Título"), i(2, "Autor"), i(0) }))

-- ----------------------------------------------------------------------------
-- 3. MATEMÁTICAS: entornos dentro de math (snippets normales)
-- ----------------------------------------------------------------------------

math_snip("cases", fmta(
  "\\begin{cases}\n\t<> & \\text{si } <> \\\\\n\t<> & \\text{en otro caso}\n\\end{cases}",
  { i(1), i(2), i(3) }
))

-- Matrices de tamaño arbitrario: pmat2x3, bmat3x3, vmat2x2, Bmat..., Vmat...
--   p -> pmatrix ( )   b -> bmatrix [ ]   v -> vmatrix | |   B -> Bmatrix { }   V -> Vmatrix ‖ ‖
local function matrix_body(_, parent)
  local snip = parent.snippet
  local rows, cols = tonumber(snip.captures[2]), tonumber(snip.captures[3])
  local nodes, idx = {}, 1
  for r = 1, rows do
    for c = 1, cols do
      nodes[#nodes + 1] = i(idx)
      idx = idx + 1
      if c < cols then
        nodes[#nodes + 1] = t(" & ")
      end
    end
    if r < rows then
      nodes[#nodes + 1] = t({ " \\\\", "\t" })
    end
  end
  return sn(nil, nodes)
end

math_auto("([pbvBV])mat(%d+)x(%d+)", fmta(
  "\\begin{<>matrix}\n\t<>\n\\end{<>matrix}",
  { capture(1), d(1, matrix_body), capture(1) }
), pattern({ priority = 1500 }))

-- ----------------------------------------------------------------------------
-- 4. MATEMÁTICAS: autosnippets (solo en zona matemática)
-- ----------------------------------------------------------------------------

-- 4.1 Letras griegas: ;a -> \alpha, ;G -> \Gamma ... (cambia el prefijo si quieres)
local greek_prefix = ";"
local greek = {
  a = "alpha", b = "beta", g = "gamma", G = "Gamma", d = "delta", D = "Delta",
  e = "varepsilon", z = "zeta", h = "eta", t = "theta", T = "Theta", vt = "vartheta",
  k = "kappa", l = "lambda", L = "Lambda", m = "mu", n = "nu", x = "xi", X = "Xi",
  p = "pi", P = "Pi", r = "rho", s = "sigma", S = "Sigma", f = "varphi", F = "Phi",
  c = "chi", y = "psi", Y = "Psi", o = "omega", O = "Omega",
}
for key, name in pairs(greek) do
  math_auto(greek_prefix .. key, t("\\" .. name))
end

-- 4.2 Símbolos, relaciones y flechas
local symbols = {
  -- relaciones
  { "<=", "\\leq" }, { ">=", "\\geq" }, { "!=", "\\neq" }, { "~~", "\\approx" },
  { "<<", "\\ll" }, { ">>", "\\gg" }, { "eqv", "\\equiv" }, { ":=", "\\coloneqq" },
  { "||", "\\mid" }, { "+-", "\\pm" },
  -- implicaciones y flechas
  { "=>", "\\implies" }, { "=<", "\\impliedby" }, { "iff", "\\iff" },
  { "->", "\\to" }, { "-->", "\\longrightarrow" }, { "|->", "\\mapsto" }, { "<->", "\\leftrightarrow" },
  -- operadores y puntos
  { "xx", "\\times" }, { "**", "\\cdot" }, { "...", "\\dots" }, { "nab", "\\nabla" },
  -- lógica y conjuntos
  { "ooo", "\\infty" }, { "AA", "\\forall" }, { "EE", "\\exists" },
  { "inn", "\\in" }, { "notin", "\\notin" }, { "cc", "\\subseteq" },
  { "Nn", "\\cap" }, { "uu", "\\cup" }, { "emp", "\\varnothing" }, { "setm", "\\setminus" },
}
for _, sym in ipairs(symbols) do
  math_auto(sym[1], t(sym[2]))
end

-- Dentro de align/aligned: == -> &=
math_auto("==", t("&= "), { condition = in_align })

-- 4.3 Conjuntos numéricos: NN, ZZ, QQ, RR, CC, FF, KK, PP
for _, letter in ipairs({ "N", "Z", "Q", "R", "C", "F", "K", "P" }) do
  math_auto(letter .. letter, t("\\mathbb{" .. letter .. "}"))
end

-- 4.4 Fuentes matemáticas (admiten selección visual)
math_auto("mbb", wrap("mathbb"))
math_auto("mcal", wrap("mathcal"))
math_auto("mfr", wrap("mathfrak"))
math_auto("mbf", wrap("mathbf"))
math_auto("msf", wrap("mathsf"))
math_auto("mrm", wrap("mathrm"))
math_auto("tt", wrap("text"))

-- 4.5 Fracciones
--   //          -> \frac{}{}
--   2/  x/  \alpha/  x^2/  x_i/   -> \frac{...}{}
--   x^{n}/  (a+b)/                -> \frac{...}{}
math_auto("//", fmta("\\frac{<>}{<>}", { i(1), i(2) }))
math_auto("([%w\\_%^]+)/", fmta("\\frac{<>}{<>}", { capture(1), i(1) }), pattern())
math_auto("([%w\\]+[_%^]%b{})/", fmta("\\frac{<>}{<>}", { capture(1), i(1) }), pattern())
math_auto("(%b())/", fmta("\\frac{<>}{<>}", {
  f(function(_, snip)
    return snip.captures[1]:sub(2, -2)
  end),
  i(1),
}), pattern())

-- 4.6 Sub/superíndices
--   x1 -> x_1,  x_12 -> x_{12}   (prioridad baja para no pisar a otros triggers)
math_auto("%f[%a](%a)(%d)", fmta("<>_<>", { capture(1), capture(2) }), pattern({ priority = 500 }))
math_auto("(%a)_(%d%d)", fmta("<>_{<>}", { capture(1), capture(2) }), pattern({ priority = 500 }))
math_auto("__", fmta("_{<>}<>", { i(1), i(0) }))
math_auto("td", fmta("^{<>}<>", { i(1), i(0) }), { wordTrig = false })
math_auto("sr", t("^2"), { wordTrig = false })
math_auto("cb", t("^3"), { wordTrig = false })
math_auto("inv", t("^{-1}"), { wordTrig = false })
math_auto("cpl", t("^{c}"), { wordTrig = false })
math_auto("tp", t("^{\\top}"), { wordTrig = false })

-- 4.7 Acentos sobre una letra: xhat -> \hat{x}, xbar -> \overline{x}, xvec, xtil, xdot
local accents = { hat = "hat", bar = "overline", vec = "vec", til = "tilde", dot = "dot" }
for trig, cmd in pairs(accents) do
  math_auto("%f[%a](%a)" .. trig, fmta("\\" .. cmd .. "{<>}", { capture(1) }), pattern())
end

-- 4.8 Operadores: sin -> \sin, etc. (ya escritos como \sin no se tocan)
local operators = {
  "sin", "cos", "tan", "cot", "sec", "csc", "arcsin", "arccos", "arctan",
  "log", "ln", "exp", "max", "min", "sup", "inf", "det", "dim", "ker", "gcd", "deg", "arg", "Pr",
}
for _, op in ipairs(operators) do
  math_auto(op, t("\\" .. op))
end

-- 4.9 Sumas, límites, integrales y derivadas
math_auto("sum", fmta("\\sum_{<>}^{<>} <>", { i(1, "n=1"), i(2, "\\infty"), i(0) }))
math_auto("prod", fmta("\\prod_{<>}^{<>} <>", { i(1, "n=1"), i(2, "\\infty"), i(0) }))
math_auto("lim", fmta("\\lim_{<> \\to <>} <>", { i(1, "n"), i(2, "\\infty"), i(0) }))
math_auto("int", fmta("\\int <> \\, \\mathrm{d}<>", { i(1), i(2, "x") }))
math_auto("dint", fmta("\\int_{<>}^{<>} <> \\, \\mathrm{d}<>", { i(1, "a"), i(2, "b"), i(3), i(4, "x") }))
math_auto("bcup", fmta("\\bigcup_{<>} <>", { i(1, "i \\in I"), i(0) }))
math_auto("bcap", fmta("\\bigcap_{<>} <>", { i(1, "i \\in I"), i(0) }))
math_auto("dd", fmta("\\frac{\\mathrm{d} <>}{\\mathrm{d} <>}", { i(1), i(2) }))
math_auto("part", fmta("\\frac{\\partial <>}{\\partial <>}", { i(1), i(2) }))

-- 4.10 Raíces, conjuntos y delimitadores (con \left ... \right)
math_auto("sq", fmta("\\sqrt{<>}<>", { d(1, get_visual), i(0) }))
math_auto("set", fmta("\\{ <> \\mid <> \\}", { i(1, "x"), i(2) }))
math_auto("U", fmta("\\underbrace{<>}_{<>}", { d(1, get_visual), i(0) }))

-- { izquierda, derecha, espacio interior }
local delimiters = {
  lrp = { "(", ")", "" },
  lrs = { "[", "]", "" },
  lrb = { "\\{", "\\}", "" },
  abs = { "\\lvert", "\\rvert", " " },
  norm = { "\\lVert", "\\rVert", " " },
  ceil = { "\\lceil", "\\rceil", " " },
  floor = { "\\lfloor", "\\rfloor", " " },
  ang = { "\\langle", "\\rangle", " " },
}
for trig, pair in pairs(delimiters) do
  local left, right, sp = pair[1], pair[2], pair[3]
  math_auto(trig, fmta("\\left" .. left .. sp .. "<>" .. sp .. "\\right" .. right .. "<>", {
    d(1, get_visual),
    i(0),
  }))
end

return snippets, autosnippets

