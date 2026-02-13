# Neovim Config

LazyVim-based config with 80+ plugins, 18 LSP servers, and full automation.

`<leader>` = `Space`

## How to Remember

All keybindings follow a **mnemonic prefix** pattern. The first letter after `<leader>` tells you the category:

| Prefix | Category | Think... |
|--------|----------|----------|
| `<leader>c` | **C**ode | actions on code (format, rename, lens, outline) |
| `<leader>d` | **D**ebug | DAP debugger controls |
| `<leader>t` | **T**est | neotest operations |
| `<leader>g` | **G**it | git hunks, diff, conflict, GitHub |
| `<leader>a` | **A**I | copilot chat commands |
| `<leader>r` | **R**efactor | extract, inline, rename |
| `<leader>s` | **S**earch | search & replace |
| `<leader>f` | **F**ile | file navigation, projects |
| `<leader>h` | **H**arpoon | quick file bookmarks |
| `<leader>x` | diagnosti**X** | trouble, todos, quickfix |
| `<leader>o` | **O**verseer | task runner |
| `<leader>u` | **U**I toggle | toggle any UI feature on/off |
| `<leader>q` | **Q**uit | session, quit |
| `<leader>w` | **W**indow | window management |
| `<leader>R` | **R**EST | HTTP client (capital R) |
| `<leader>m` | **M**arkdown | preview |
| `<leader>z` | **Z**en | zen mode, zoom |
| `g` | **G**o to | LSP go-to, preview, surround |
| `[` / `]` | **Prev/Next** | jump to prev/next of anything |

**Second letter** narrows it down:
- `<leader>gh` = **G**it **H**unk (stage, reset, preview)
- `<leader>gc` = **G**it **C**onflict (choose ours/theirs)
- `<leader>gv` = **G**it **V**iew (diffview)
- `<leader>gH` = **G**it**H**ub (issues, PRs)
- `<leader>da` = **D**ebug **A**dapter (lua)

**Bracket jumps** `[` / `]` are consistent:
- `]h` / `[h` = next/prev **h**unk
- `]t` / `[t` = next/prev **t**odo
- `]q` / `[q` = next/prev **q**uickfix
- `]T` / `[T` = next/prev failed **T**est
- `]x` / `[x` = next/prev conflict
- `]r` / `[r` = next/prev **r**equest
- `]<space>` / `[<space>` = add blank line below/above

## Keybindings

### General

| Key | Mode | Description |
|-----|------|-------------|
| `<Esc>` | n | Clear search highlight |
| `x` then `p` | v | Paste without yanking |
| `J` | n | Join lines (cursor stays) |
| `<C-d>` | n | Page down (centered) |
| `<C-u>` | n | Page up (centered) |
| `]<space>` | n | Add blank line below |
| `[<space>` | n | Add blank line above |
| `jk` / `jj` | i | Escape insert mode |
| `,` `.` `;` | i | Undo breakpoints |

### Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h/j/k/l>` | n | Move between windows |
| `<M-h/j/k/l>` | n, v | Move lines/blocks |
| `s` | n | Flash jump |
| `S` | n, x, o | Flash treesitter |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `n` / `N` | n | Next/prev match (centered, with count) |
| `*` / `#` | n | Search word forward/backward |
| `-` | n | Open mini.files (current file) |

### LSP

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition (LazyVim) |
| `gD` | n | Go to declaration |
| `gr` | n | References (LazyVim) |
| `gK` | n | Signature help |
| `K` | n | Hover doc (Lspsaga) |
| `<C-k>` | i | Signature help |
| `<leader>ca` | n, v | Code action (Lspsaga) |
| `<leader>cA` | n | LSP finder (Lspsaga) |
| `<leader>cp` | n | Peek definition (Lspsaga) |
| `<leader>cD` | n | Peek type definition (Lspsaga) |
| `<leader>cr` | n | Rename (incremental) |
| `<leader>cl` | n | Run CodeLens |
| `<leader>cL` | n | Refresh CodeLens |
| `<leader>cs` | n | Symbols (Trouble) |
| `<leader>cS` | n | LSP references (Trouble) |
| `<leader>co` | n | Toggle outline |
| `<leader>cg` | n | Generate docs (Neogen) |
| `<leader>cj` | n | Split/join toggle |
| `<leader>cJ` | n | Split/join recursive |

### LSP Preview (goto-preview)

| Key | Mode | Description |
|-----|------|-------------|
| `gpd` | n | Preview definition |
| `gpt` | n | Preview type definition |
| `gpi` | n | Preview implementation |
| `gpr` | n | Preview references |
| `gP` | n | Close all previews |

### File Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>fm` | n | Mini files (current file) |
| `<leader>fM` | n | Mini files (cwd) |
| `<leader>fp` | n | Projects |
| `<leader>e` | n | File explorer (LazyVim/snacks) |

### Harpoon

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ha` | n | Add file to harpoon |
| `<leader>hh` | n | Harpoon menu |
| `<leader>h1-5` | n | Jump to harpoon file 1-5 |
| `<leader>hp` | n | Previous harpoon file |
| `<leader>hn` | n | Next harpoon file |
| `<M-1/2/3/4>` | n | Quick jump to harpoon 1-4 |

### Search & Replace

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sr` | n | Search and replace (grug-far) |
| `<leader>sr` | v | Replace selection |
| `<leader>sR` | n | Replace in current file |

### Formatting

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cf` | n, v | Format |
| `<leader>cF` | n, v | Format injected code |
| `<leader>uf` | n | Toggle autoformat (buffer) |
| `<leader>uF` | n | Toggle autoformat (global) |

### Diagnostics (Trouble)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>xx` | n | Toggle diagnostics |
| `<leader>xX` | n | Buffer diagnostics |
| `<leader>xL` | n | Location list |
| `<leader>xQ` | n | Quickfix list |
| `<leader>xt` | n | Todo (Trouble) |
| `<leader>xT` | n | Todo/Fix/Fixme only |
| `[q` / `]q` | n | Prev/next item |
| `[t` / `]t` | n | Prev/next todo |

### Git

| Key | Mode | Description |
|-----|------|-------------|
| `]h` / `[h` | n | Next/prev hunk |
| `<leader>ghs` | n, v | Stage hunk |
| `<leader>ghr` | n, v | Reset hunk |
| `<leader>ghS` | n | Stage buffer |
| `<leader>ghR` | n | Reset buffer |
| `<leader>ghu` | n | Undo stage hunk |
| `<leader>ghp` | n | Preview hunk |
| `<leader>ghP` | n | Preview hunk inline |
| `<leader>ghb` | n | Blame line |
| `<leader>ghB` | n | Toggle line blame |
| `<leader>ghd` | n | Diff this |
| `<leader>ghD` | n | Diff this ~ |
| `ih` | o, x | Select hunk (text object) |

### Git Conflict

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gco` | n | Choose ours |
| `<leader>gct` | n | Choose theirs |
| `<leader>gcb` | n | Choose both |
| `<leader>gc0` | n | Choose none |
| `[x` / `]x` | n | Prev/next conflict |

### Git Diffview

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gvd` | n | Diffview open |
| `<leader>gvD` | n | Diffview close |
| `<leader>gvh` | n | File history |
| `<leader>gvH` | n | Branch history |

### GitHub (gh.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gHi` | n | Open issue |
| `<leader>gHo` | n | Open PR |
| `<leader>gHP` | n | Preview PR |
| `<leader>gHT` | n | Toggle threads |
| `<leader>gHn` | n | Notifications |

### Debugging (DAP)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>db` | n | Toggle breakpoint |
| `<leader>dB` | n | Breakpoint with condition |
| `<leader>dc` | n | Continue |
| `<leader>dC` | n | Run to cursor |
| `<leader>di` | n | Step into |
| `<leader>do` | n | Step out |
| `<leader>dO` | n | Step over |
| `<leader>dg` | n | Go to line |
| `<leader>dp` | n | Pause |
| `<leader>dl` | n | Run last |
| `<leader>dr` | n | Toggle REPL |
| `<leader>ds` | n | Session |
| `<leader>dt` | n | Terminate |
| `<leader>du` | n | Toggle DAP UI |
| `<leader>de` | n, v | Eval expression |
| `<leader>dw` | n | Widgets |
| `<leader>dj` / `<leader>dk` | n | Stack down/up |
| `<leader>daL` | n | Launch Lua debug server |
| `<leader>dal` | n | Debug current Lua file |
| `<F5>` | n | Continue |
| `<F10>` | n | Step over |
| `<F11>` | n | Step into |
| `<F12>` | n | Step out |

### Testing (Neotest)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tt` | n | Run nearest test |
| `<leader>tf` | n | Run file tests |
| `<leader>tT` | n | Run all tests |
| `<leader>tl` | n | Run last test |
| `<leader>ts` | n | Toggle summary |
| `<leader>to` | n | Show output |
| `<leader>tO` | n | Toggle output panel |
| `<leader>tS` | n | Stop test |
| `<leader>tw` | n | Toggle watch |
| `<leader>td` | n | Debug nearest test |
| `<leader>tD` | n | Debug file tests |
| `[T` / `]T` | n | Prev/next failed test |

### AI (Copilot Chat)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>aa` | n | Toggle chat |
| `<leader>ae` | n, v | Explain code |
| `<leader>ar` | n, v | Review code |
| `<leader>af` | n, v | Fix code |
| `<leader>ao` | n, v | Optimize code |
| `<leader>ad` | n, v | Generate docs |
| `<leader>at` | n, v | Generate tests |
| `<leader>am` | n | Generate commit message |
| `<leader>aq` | n | Quick chat (prompt) |
| `<leader>ax` | n | Reset chat |
| `<leader>aD` | n | Debug info |

### Refactoring

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>re` | v | Extract function |
| `<leader>rf` | v | Extract function to file |
| `<leader>rv` | v | Extract variable |
| `<leader>ri` | n, v | Inline variable |
| `<leader>rI` | n | Inline function |
| `<leader>rb` | n | Extract block |
| `<leader>rB` | n | Extract block to file |
| `<leader>rr` | n, v | Select refactor |
| `<leader>rp` | n | Debug printf |
| `<leader>rP` | n, v | Debug print var |
| `<leader>rc` | n | Debug cleanup |

### Task Runner (Overseer)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ot` | n | Toggle task list |
| `<leader>or` | n | Run task |
| `<leader>oR` | n | Run command |
| `<leader>ob` | n | Build |
| `<leader>oq` | n | Quick action |
| `<leader>oa` | n | Task action |
| `<leader>oi` | n | Info |
| `<leader>oc` | n | Clear cache |

### REST Client (Kulala) — `.http` files

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>Rs` | n | Send request |
| `<leader>Ra` | n | Send all requests |
| `<leader>Rr` | n | Replay last |
| `<leader>Ri` | n | Inspect |
| `<leader>Rt` | n | Toggle view |
| `<leader>Rc` | n | Copy as cURL |
| `<leader>Rp` | n | REST scratchpad |
| `[r` / `]r` | n | Prev/next request |

### Folding (UFO)

| Key | Mode | Description |
|-----|------|-------------|
| `zR` | n | Open all folds |
| `zM` | n | Close all folds |
| `zr` | n | Open folds except kinds |
| `zm` | n | Close folds with level |
| `zp` | n | Peek folded lines |

### Surround (mini.surround)

| Key | Mode | Description |
|-----|------|-------------|
| `gsa` | n | Add surround |
| `gsd` | n | Delete surround |
| `gsr` | n | Replace surround |
| `gsf` | n | Find surround |
| `gsF` | n | Find surround (left) |
| `gsh` | n | Highlight surround |

### Increment/Decrement (Dial)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-a>` | n, v | Increment (numbers, booleans, dates, etc.) |
| `<C-x>` | n, v | Decrement |
| `g<C-a>` | n, v | Increment (sequence) |
| `g<C-x>` | n, v | Decrement (sequence) |

Smart cycling: `true/false`, `yes/no`, `let/const/var`, `==`/`!=`, `public/private/protected`, `GET/POST/PUT/PATCH/DELETE`, and more.

### Yank (Yanky)

| Key | Mode | Description |
|-----|------|-------------|
| `y` | n, v | Yank (tracked) |
| `p` / `P` | n | Put after/before (tracked) |
| `[y` / `]y` | n | Cycle yank history |

### Marks

| Key | Mode | Description |
|-----|------|-------------|
| `m,` | n | Set next mark |
| `m]` / `m[` | n | Next/prev mark |
| `m:` | n | Preview mark |
| `dm-` | n | Delete mark on line |
| `dm<space>` | n | Delete all marks in buffer |

### Session & Quit

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>qs` | n | Restore session |
| `<leader>ql` | n | Restore last session |
| `<leader>qd` | n | Don't save session |
| `<leader>qQ` | n | Quit all (force) |

### Toggles

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>uw` | n | Toggle wrap (LazyVim) |
| `<leader>ul` | n | Toggle line numbers (LazyVim) |
| `<leader>uL` | n | Toggle relative numbers (LazyVim) |
| `<leader>us` | n | Toggle spell (LazyVim) |
| `<leader>ud` | n | Toggle diagnostics (LazyVim) |
| `<leader>uh` | n | Toggle inlay hints (LazyVim) |
| `<leader>uC` | n | Toggle cursor line |
| `<leader>uf` | n | Toggle autoformat (buffer) |
| `<leader>uF` | n | Toggle autoformat (global) |
| `<leader>ut` | n | Toggle twilight (dim inactive) |
| `<leader>um` | n | Toggle render markdown |
| `<leader>up` | n | Toggle precognition (movement hints) |
| `<leader>uu` | n | Toggle undo tree |
| `<leader>uV` | n | Vim Be Good (practice) |

### Windows & Zen

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>wm` | n | Maximize window |
| `<leader>w=` | n | Equalize windows |
| `<leader>z` | n | Zen mode |
| `<leader>Z` | n | Zoom |

### Markdown

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>mp` | n | Markdown preview (browser) |
| `<leader>um` | n | Toggle render markdown (in-buffer) |

### Terminal

| Key | Mode | Description |
|-----|------|-------------|
| `<Esc><Esc>` | t | Exit terminal mode |
| `<C-/>` | t | Hide terminal |
| `<C-h/j/k/l>` | t | Navigate from terminal (LazyVim) |

### Command Mode

| Key | Mode | Description |
|-----|------|-------------|
| `<C-a>` | c | Start of line |
| `<C-e>` | c | End of line |
| `<C-h>` | c | Left |
| `<C-l>` | c | Right |

### Text Objects

| Key | Description |
|-----|-------------|
| `af` / `if` | Function (outer/inner) |
| `ac` / `ic` | Class (outer/inner) |
| `ao` / `io` | Block/conditional/loop |
| `at` / `it` | HTML tag |
| `ad` / `id` | Digit sequence |
| `ae` / `ie` | Word segment (camelCase) |
| `au` / `iu` | Function call |
| `ih` | Git hunk |
| `<C-space>` | Init/extend treesitter selection |
| `<BS>` | Reduce treesitter selection |

## LSP Servers

| Language | Server |
|----------|--------|
| Lua | lua_ls |
| Python | pyright + ruff |
| Go | gopls |
| TypeScript/JavaScript | ts_ls |
| JSON | jsonls + SchemaStore |
| YAML | yamlls + SchemaStore |
| Svelte | svelte |
| Tailwind | tailwindcss |
| HTML | html |
| CSS | cssls |
| Emmet | emmet_ls |
| TOML | taplo |
| Markdown | marksman |
| Docker | dockerls |
| Docker Compose | docker_compose_language_service |
| Bash | bashls |

## Formatters

| Language | Formatter |
|----------|-----------|
| TypeScript/JavaScript/React | biome > prettier |
| Python | ruff_format |
| Go | goimports + gofumpt |
| Lua | stylua |
| Shell | shfmt |
| HTML/CSS/SCSS/Svelte/Vue | prettier |
| JSON/JSONC | biome > prettier |
| YAML | prettier |
| Markdown | prettier + markdownlint |
| TOML | taplo |
| SQL | sql_formatter |
| GraphQL | prettier |
| PHP | php_cs_fixer |
| Dart | dart_format |
| All files | trim_whitespace |

## DAP Configurations

| Language | Configs |
|----------|---------|
| Python | Launch file, launch with args, attach to process |
| Go | Launch file, launch package, test file, test package, attach |
| JavaScript/TypeScript | Launch file, launch file (bun), attach, vitest, jest |
| Lua | Attach to running Neovim instance |
