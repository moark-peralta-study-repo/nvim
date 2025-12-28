local M = {}

-- Get paths to JDTLS launcher, config, and lombok
local function get_jdtls()
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]

  local config = mason_path .. "/config_linux"
  local lombok = mason_path .. "/lombok.jar"

  print("Launcher:", launcher)
  print("Mason Path", mason_path)
  print("Config:", config)
  print("Lombok:", lombok)

  return launcher, config, lombok
end

local function get_bundles()
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  local bundles = {}

  local java_debug =
    vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)

  local java_test = vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true, true)

  vim.list_extend(bundles, java_debug)
  vim.list_extend(bundles, java_test)

  return bundles
end

-- Get workspace directory
local function get_workspace()
  local home = os.getenv("HOME")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  if project_name == "" then
    project_name = "jdtls-temp"
  end
  local workspace_dir = home .. "/.cache/jdtls-workspace/" .. project_name
  vim.fn.mkdir(workspace_dir, "p")
  return workspace_dir
end

-- Java keymaps
local function java_keymaps()
  vim.cmd(
    "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
  )
  vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
  vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
  vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

  local opts = { noremap = true, silent = true }

  -- Organize imports
  vim.keymap.set(
    "n",
    "<leader>Jo",
    "<Cmd>lua require('jdtls').organize_imports()<CR>",
    { desc = "[J]ava [O]rganize Imports" }
  )
  -- Extract variable
  vim.keymap.set(
    "n",
    "<leader>Jv",
    "<Cmd>lua require('jdtls').extract_variable()<CR>",
    { desc = "[J]ava Extract [V]ariable" }
  )
  vim.keymap.set(
    "v",
    "<leader>Jv",
    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    { desc = "[J]ava Extract [V]ariable" }
  )
  -- Extract constant
  vim.keymap.set(
    "n",
    "<leader>JC",
    "<Cmd>lua require('jdtls').extract_constant()<CR>",
    { desc = "[J]ava Extract [C]onstant" }
  )
  vim.keymap.set(
    "v",
    "<leader>JC",
    "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
    { desc = "[J]ava Extract [C]onstant" }
  )
  -- Test method/class
  vim.keymap.set(
    "n",
    "<leader>Jt",
    "<Cmd>lua require('jdtls').test_nearest_method()<CR>",
    { desc = "[J]ava [T]est Method" }
  )
  vim.keymap.set(
    "v",
    "<leader>Jt",
    "<Esc><Cmd>lua require('jdtls').test_nearest_method(true)<CR>",
    { desc = "[J]ava [T]est Method" }
  )
  vim.keymap.set("n", "<leader>JT", "<Cmd>lua require('jdtls').test_class()<CR>", { desc = "[J]ava [T]est Class" })
  vim.keymap.set("n", "<leader>Ju", "<Cmd>JdtUpdateConfig<CR>", { desc = "[J]ava [U]pdate Config" })
end

-- Main setup function
function M.setup_jdtls()
  local jdtls = require("jdtls")
  local launcher, os_config, lombok = get_jdtls()
  local workspace_dir = get_workspace()
  local bundles = get_bundles()

  -- Determine root dir
  -- local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".java-workspace" })
  --
  --
  local root_dir = require("jdtls.setup").find_root({
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    ".java-workspace",
  }) or vim.fn.getcwd()

  local capabilities
  local ok
  if ok then
    -- capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities()
  else
    capabilities = {}
  end

  -- Extended client capabilities
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  -- JDTLS command
  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok,
    "-jar",
    launcher,
    "-configuration",
    os_config,
    "-data",
    workspace_dir,
  }

  -- JDTLS settings
  local settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      eclipse = { downloadSource = true },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      saveActions = { organizeImports = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = { "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*" },
        importOrder = { "java", "jakarta", "javax", "com", "org" },
      },
      sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
      configuration = { updateBuildConfiguration = "interactive" },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
    },
  }

  local init_options = { bundles = bundles, extendedClientCapabilities = extendedClientCapabilities }

  local on_attach = function(_, bufnr)
    java_keymaps()

    require("dap")

    require("jdtls.dap").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()

    -- vim.lsp.codelens.refresh()
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
    vim.lsp.codelens.refresh()

    vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold", "BufWritePost" }, {
      -- pattern = { "*.java" },
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
    })
  end

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    capabilities = capabilities,
    init_options = init_options,
    on_attach = on_attach,
  }

  jdtls.start_or_attach(config)
end

return M
