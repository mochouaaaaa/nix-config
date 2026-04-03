{ pkgs, ... }:
{
  programs = {
    mcp = {
      enable = true;
      servers = {
        everything = {
          command = "${pkgs.nodejs_25}/bin/npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-everything"
          ];
        };
      };
    };
    codex.enableMcpIntegration = true;
    opencode.enableMcpIntegration = true;
    zed-editor.enableMcpIntegration = true;
    claude-code.enableMcpIntegration = true;
    vscode.profiles.default = {
      userMcp = { };
      enableMcpIntegration = true;
    };
  };

}
