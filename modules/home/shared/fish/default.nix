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
      "reboot" = ''printf "Are you sure you want to reboot? [N/y]\n"; read -n 1 confirm; test "$confirm" = y && sudo reboot'';
      "down" = ''kubectl scale deploy,statefulset -n apps --all --replicas=0 && kubectl scale deploy,statefulset -n media --all --replicas=0 && kubectl scale deploy,statefulset -n infra --all --replicas=0 && k3s-killall.sh'';
      "up" = ''kubectl scale deploy,statefulset -n apps --all --replicas=1 && kubectl scale deploy,statefulset -n media --all --replicas=1 && kubectl scale deploy,statefulset -n infra --all --replicas=1'';
    };
  };
}
