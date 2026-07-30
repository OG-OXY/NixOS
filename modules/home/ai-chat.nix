{
  ...
}:
{
  programs.aichat = {
    enable = true;
    settings = {
      model = "local:qwen2.5-coder";
      clients = [
        {
          type = "openai-compatible";
          name = "local";
          api_base = "http://127.0.0.1:8012/v1"; # Replace with your local port/path
          api_key = "not-needed"; # Some clients require a placeholder string
          models = [
            {
              name = "qwen2.5-coder"; # MUST match the exact name your local backend expects
              max_input_tokens = 32768;
            }
          ];
        }
      ];
    };
  };
}
