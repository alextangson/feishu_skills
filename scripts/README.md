Shared helper scripts for `feishu_skills`.

`get_feishu_token.sh` reads `FEISHU_APP_ID` / `FEISHU_APP_SECRET`, caches the
tenant token in `../.feishu_token_cache.json`, and prints the current token to
stdout.
