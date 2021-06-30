lua << EOF
require("true-zen").setup({
    minimalist = { store_and_restore_settings = true },
    integrations = {
        integration_tmux = false,
        integration_limelight = false
    }
})
EOF
