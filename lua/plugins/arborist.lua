---@module "lazy"

---@type LazyPluginSpec
return {
    "arborist-ts/arborist.nvim",
    lazy = false,
    opts = {
        disable = {
            highlight = {
                "latex",
            }
        }
    }
}
