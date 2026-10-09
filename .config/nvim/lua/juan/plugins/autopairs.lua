return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  -- blink.cmp ya añade los paréntesis al aceptar una función (auto_brackets)
  opts = {
    check_ts = true, -- enable treesitter
    ts_config = {
      lua = { "string" }, -- don't add pairs in lua string treesitter nodes
      javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
      java = false, -- don't check treesitter on java
    },
  },
}
