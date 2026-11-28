{
  flake.aspects.launcher.providers.vicinae.homeManager =
    { config, ... }:
    let
      extensions = config.profiles.vicinae.extensions;
    in
    {

      programs.vicinae = {
        extensions = with extensions; [
          ollama-wordsmith
        ];
        settings = {
          providers = {
            "@AdityaZxxx/${extensions.ollama-wordsmith.name}" = {
              "preferences" = {
                "ollamaUrl" = "http://localhost:11434";
                # "defaultModel" = "translategemma:latest";
                "defaultModel" = "modelscope.cn/42ailab/TranslateGemma-4B-GGUF:Q8_0";
                "targetLanguage" = "Chinese";
                "maxHistorySize" = "50";
              };
              "entrypoints" = {
                "translate" = {
                  "alias" = "ff";
                };
              };
            };
          };
        };
      };
    };
}
