local frontend_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
  css = true,
  scss = true,
  less = true,
  html = true,
}

local function is_frontend_context(context)
  local filetype = context and context.filetype or vim.bo.filetype
  return frontend_filetypes[filetype] == true
end

local function target_code(context, selection_instruction, buffer_instruction)
  if context.is_visual and context.code and context.code ~= "" then
    return string.format("%s\n\n````%s\n%s\n````", selection_instruction, context.filetype, context.code)
  end

  return string.format("%s\n\n请结合 #{buffer} 的内容来处理。", buffer_instruction)
end

require("codecompanion").setup({
  opts = {
    log_level = "ERROR",
  },
  display = {
    action_palette = {
      provider = "telescope",
    },
    diff = {
      enabled = true,
      threshold_for_chat = 8,
      window = {
        opts = {
          number = true,
        },
      },
      word_highlights = {
        additions = true,
        deletions = true,
      },
    },
  },
  interactions = {
    chat = {
      adapter = "copilot",
      opts = {
        completion_provider = "blink",
        context_management = {
          enabled = true,
          trigger = 0.8,
        },
        system_prompt = function(ctx)
          return table.concat({
            ctx.default_system_prompt,
            "",
            "Additional workflow requirements:",
            "- All non-code explanations must be written in Simplified Chinese.",
            "- Lead with the conclusion, then explain the key reasoning or actionable steps.",
            "- Keep identifiers, API names, framework names, commit message candidates, and terminal commands in English.",
            "- Prefer concise, implementation-oriented answers over generic background exposition.",
            "- When suggesting code changes, preserve the existing project style and avoid unnecessary renames or restructuring.",
          }, "\n")
        end,
      },
    },
    inline = {
      adapter = "copilot",
    },
    cmd = {
      adapter = "copilot",
    },
  },
  prompt_library = {
    ["中文解释代码"] = {
      interaction = "chat",
      description = "用中文解释选中代码或当前文件",
      opts = {
        alias = "explain_cn",
        auto_submit = true,
        is_slash_cmd = true,
        intro_message = "我会用中文解释代码的职责、流程和关键细节。",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名资深软件工程师。请用简体中文解释代码，优先说明作用、执行流程、关键依赖、边界条件和潜在风险。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请用中文解释这段代码的作用、执行流程、关键依赖、边界条件和需要特别注意的实现细节。",
              "请用中文解释当前文件的职责、主要结构、数据流以及需要特别注意的实现细节。"
            )
          end,
        },
      },
    },
    ["中文修复问题"] = {
      interaction = "inline",
      description = "修复选中代码中的明显问题",
      opts = {
        alias = "fix_cn",
        auto_submit = true,
        modes = { "v" },
        placement = "replace",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名资深软件工程师。请直接修复代码，优先处理 bug、类型问题、空值问题、异步问题和边界条件。只返回可以直接替换原选区的代码。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请修复这段代码中的明显问题，保持原有功能意图和现有代码风格，不要改动无关逻辑。只返回修复后的代码。",
              "请修复当前文件中的明显问题，保持原有功能意图和现有代码风格。"
            )
          end,
        },
      },
    },
    ["中文重构代码"] = {
      interaction = "inline",
      description = "重构选中代码但不改变行为",
      opts = {
        alias = "refactor_cn",
        auto_submit = true,
        modes = { "v" },
        placement = "replace",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名资深软件工程师。请在不改变外部行为的前提下重构代码，提升可读性、可维护性和命名质量。只返回可以直接替换原选区的代码。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请重构这段代码，在不改变行为的前提下提升可读性、结构和可维护性。只返回重构后的代码。",
              "请重构当前文件中最值得优化的部分，在不改变行为的前提下提升可读性和可维护性。"
            )
          end,
        },
      },
    },
    ["中文补测试"] = {
      interaction = "chat",
      description = "为选中代码或当前文件生成测试思路与样例",
      opts = {
        alias = "tests_cn",
        auto_submit = true,
        is_slash_cmd = true,
        intro_message = "我会先给出测试重点，再给出可直接落地的测试样例。",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名擅长测试设计的资深工程师。请用简体中文输出，优先给出测试重点、边界场景，再给出尽量可运行的测试样例。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请为这段代码生成测试方案与测试样例。优先覆盖主流程、边界条件、异常场景和回归风险，并尽量贴合当前技术栈常用测试框架。",
              "请为当前文件生成测试方案与测试样例。优先覆盖主流程、边界条件、异常场景和回归风险，并尽量贴合当前技术栈常用测试框架。"
            )
          end,
        },
      },
    },
    ["中文总结文件"] = {
      interaction = "chat",
      description = "总结当前文件的职责和重点",
      opts = {
        alias = "summary_cn",
        auto_submit = true,
        is_slash_cmd = true,
      },
      prompts = {
        {
          role = "system",
          content = "你是一名资深软件工程师。请用简体中文总结文件，先给结论，再给结构、数据流、关键风险和后续建议。",
        },
        {
          role = "user",
          content = "请总结 #{buffer} 的职责、主要结构、关键数据流、潜在风险，以及接下来最值得优先关注的改进点。",
        },
      },
    },
    ["前端解释组件"] = {
      interaction = "chat",
      description = "解释前端组件、Hook、状态和渲染逻辑",
      condition = is_frontend_context,
      opts = {
        alias = "frontend_explain",
        auto_submit = true,
        is_slash_cmd = true,
        intro_message = "我会从组件职责、状态流、渲染逻辑和副作用几个角度解释。",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名前端高级工程师，熟悉 TypeScript、React、Vue、状态管理和组件设计。请用简体中文解释代码，优先说明组件职责、props 或输入输出、状态流、渲染逻辑、副作用、性能点和可维护性风险。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请从组件职责、props/输入输出、状态流、渲染逻辑、副作用、性能和维护风险几个角度解释这段前端代码。",
              "请从组件职责、props/输入输出、状态流、渲染逻辑、副作用、性能和维护风险几个角度解释当前前端文件。"
            )
          end,
        },
      },
    },
    ["前端修复选中代码"] = {
      interaction = "inline",
      description = "修复前端选中代码中的类型、状态或渲染问题",
      condition = is_frontend_context,
      opts = {
        alias = "frontend_fix",
        auto_submit = true,
        modes = { "v" },
        placement = "replace",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名前端高级工程师。请修复选中代码中的 bug、类型错误、状态同步问题、渲染问题、事件处理问题和副作用问题。保持现有框架风格，只返回可直接替换原选区的代码。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请修复这段前端代码中的问题，优先处理 TypeScript 类型、状态管理、渲染逻辑、事件处理、空值安全和副作用问题。只返回修复后的代码。",
              "请修复当前前端文件中最明显的问题。"
            )
          end,
        },
      },
    },
    ["前端重构选中代码"] = {
      interaction = "inline",
      description = "重构前端选中代码，改善可维护性",
      condition = is_frontend_context,
      opts = {
        alias = "frontend_refactor",
        auto_submit = true,
        modes = { "v" },
        placement = "replace",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名前端高级工程师。请在不改变外部行为的前提下重构代码，提升组件可读性、状态组织、类型表达、复用性和性能可维护性。只返回可直接替换原选区的代码。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请重构这段前端代码，在不改变外部行为的前提下提升组件结构、状态组织、类型表达、复用性和可维护性。只返回重构后的代码。",
              "请重构当前前端文件中最值得优化的部分。"
            )
          end,
        },
      },
    },
    ["前端生成测试"] = {
      interaction = "chat",
      description = "为前端组件或逻辑生成测试方案与样例",
      condition = is_frontend_context,
      opts = {
        alias = "frontend_tests",
        auto_submit = true,
        is_slash_cmd = true,
        intro_message = "我会优先给出组件测试重点，再给出贴近 Vitest/Jest + Testing Library 的样例。",
      },
      prompts = {
        {
          role = "system",
          content = "你是一名前端测试工程师，熟悉 Vitest、Jest、Testing Library 和组件测试。请用简体中文说明测试重点，并尽量给出可直接落地的测试样例。",
        },
        {
          role = "user",
          content = function(context)
            return target_code(
              context,
              "请为这段前端代码生成测试方案与测试样例，优先覆盖渲染、交互、状态变化、副作用、边界条件和回归风险，并优先使用 Vitest 或 Jest 搭配 Testing Library 的风格。",
              "请为当前前端文件生成测试方案与测试样例，优先覆盖渲染、交互、状态变化、副作用、边界条件和回归风险，并优先使用 Vitest 或 Jest 搭配 Testing Library 的风格。"
            )
          end,
        },
      },
    },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>ia", "<cmd>CodeCompanionActions<CR>", { desc = "AI [A]ctions" })
vim.keymap.set("n", "<leader>ic", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "AI [C]hat" })
vim.keymap.set({ "n", "v" }, "<leader>ii", "<cmd>CodeCompanion<CR>", { desc = "AI [I]nline prompt" })
vim.keymap.set("v", "<leader>is", "<cmd>CodeCompanionChat Add<CR>", { desc = "AI [S]end selection" })
vim.keymap.set({ "n", "v" }, "<leader>ie", function()
  require("codecompanion").prompt("explain_cn")
end, { desc = "AI [E]xplain" })
vim.keymap.set("v", "<leader>ifx", function()
  require("codecompanion").prompt("fix_cn")
end, { desc = "AI [F]ix selection" })
vim.keymap.set("v", "<leader>ir", function()
  require("codecompanion").prompt("refactor_cn")
end, { desc = "AI [R]efactor selection" })
vim.keymap.set({ "n", "v" }, "<leader>it", function()
  require("codecompanion").prompt("tests_cn")
end, { desc = "AI [T]ests" })
vim.keymap.set("n", "<leader>im", function()
  require("codecompanion").prompt("summary_cn")
end, { desc = "AI Su[m]marize file" })
vim.keymap.set({ "n", "v" }, "<leader>ife", function()
  require("codecompanion").prompt("frontend_explain")
end, { desc = "AI [F]rontend [E]xplain" })
vim.keymap.set("v", "<leader>iff", function()
  require("codecompanion").prompt("frontend_fix")
end, { desc = "AI [F]rontend [F]ix" })
vim.keymap.set("v", "<leader>ifr", function()
  require("codecompanion").prompt("frontend_refactor")
end, { desc = "AI [F]rontend [R]efactor" })
vim.keymap.set({ "n", "v" }, "<leader>ift", function()
  require("codecompanion").prompt("frontend_tests")
end, { desc = "AI [F]rontend [T]ests" })

vim.cmd([[cab cc CodeCompanion]])
