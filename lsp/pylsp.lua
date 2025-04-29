return {
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
            plugins = {
                autopep8 = {
                    enabled = false,
                },
                pycodestyle = {
                    enabled = false,
                },
                jedi_completion = {
                    eager = true,
                },
                mccabe = {
                    enabled = false,
                },
                pyflakes = {
                    enabled = false,
                },
                flake8 = {
                    enabled = true,
                    maxLineLength = 120,
                    extendIgnore = { "E265", "E203", "E741" },
                },
                rope_autoimport = {
                    enabled = false,
                    completions = {
                        enabled = false
                    }
                },
                black = {
                    enabled = true,
                },
            }
        },
    }
}
