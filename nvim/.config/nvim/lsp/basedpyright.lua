return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  settings = {
    basedpyright = {
      typeCheckingMode = "basic",
      analysis = {
        diagnosticSeverityOverrides = {
          reportMissingParameterType = false,
          reportUnknownParameterType = false,
        },
      },
    },
  },
}
