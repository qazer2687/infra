{
  lib,
  config,
  ...
}: {
  options.modules.fish.enable = lib.mkEnableOption "";
  config = lib.mkIf config.modules.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # disable greeting
        export TERM="xterm"
      '';

      functions = {
        fish_prompt = ''

          # Get user and hostname with default colors
          set -l current_user (whoami)
          set -l host_name (hostname -s)
          # Default fish prompt styling
          echo -n -s "$nix_shell_info" \
            (set_color e60000) "$current_user" \
            (set_color normal) "@" \
            (set_color e60000) "$host_name" \
            (set_color normal) " " \
            (set_color e60000) (prompt_pwd) \
            (set_color normal) "> "
        '';

        nix-shell = ''
          command nix-shell --run fish $argv
        '';
      };
    };

    home.shellAliases = {
      "check" = ''nix-shell -p alejandra -p deadnix -p statix --command "alejandra -q . && deadnix -e && statix fix"'';
      "rebuild" = "nh os switch github:qazer2687/dotfiles -H $(hostname) -- --refresh --option eval-cache false";
      "reboot" = ''kubectl drain fern --ignore-daemonsets --delete-emptydir-data --force --disable-eviction --timeout=120s && sudo reboot'';
    };
  };
}
