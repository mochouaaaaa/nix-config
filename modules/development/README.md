# Development modules

Development language modules are Home Manager modules. Each language remains independently selectable; the aggregate entries are convenience bundles only.

## Language modules

| Module ID | Responsibility |
| --- | --- |
| `development.go` | Go toolchain, language server, formatters, debugger and Go environment |
| `development.node` | npm / Node.js and Yarn configuration |
| `development.python` | Python tooling (ty, Ruff, uv) and Playwright browser runtime |
| `development.rust` | rustup and Cargo / Rustup environment |

## Bundles

- `development.languages` imports the four language modules above.
- `development` is the compatibility entry point and imports `development.languages`. The `homeManager.workstation` role continues to use this ID, so its existing toolchain selection is unchanged.
- `development.gui` remains a separate opt-in Home Manager module for graphical IDE integrations. It conditionally adds GoLand when Go is enabled, PyCharm when ty is enabled, and the JetBrains support package. It is not included automatically by `development` or `workstation`.

A Host can import one or more atomic language modules instead of the full bundle. Preservation declarations remain alongside the language/tool module that owns the corresponding user state; they are not folded into the Home Manager aggregate.

## Platform notes

Go's project path differs between Darwin and other platforms. Node.js and npm use the same Node.js package version. Project-local Node.js versions are intentionally not inferred by the global preservation module.

JetBrains IDE applications are optional GUI tooling and should be selected by desktop-capable Hosts explicitly through `development.gui`.
