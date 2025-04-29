return {
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> {}"
            },
            formatting = {
                command = { "alejandra" }
            },
            options = {
                nixos = {
                    expr = "(builtins.getFlake \"" ..
                        vim.fn.expand("~") .. "/nixfiles\").nixosConfigurations." .. vim.fn.hostname() .. ".config"
                },
            }
        },
    }
}
