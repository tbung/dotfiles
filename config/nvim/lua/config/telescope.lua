require('telescope').setup{
    extensions = {
        project = {
            base_dirs = {
                '~/Projects',
            }
        }
    }
}
require('telescope').load_extension('project')
require("telescope").load_extension("git_worktree")
