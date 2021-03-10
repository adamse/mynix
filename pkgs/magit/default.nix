{ stdenv, emacsPackagesGen, emacs, git, runCommand }:

let
  emacsWithPackages = (emacsPackagesGen emacs).emacsWithPackages;
  emacs-magit = emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit
  ]));

  script = ''
    #!${stdenv.shell}

    if ! ${git}/bin/git rev-parse --quiet --show-toplevel; then
      exit 1
    fi

    export TERM=xterm-256color
    ${emacs-magit}/bin/emacs --no-window-system --quick --load @out@/init.el
  '';

  initel = ''
    ;; Declutter interface
    (menu-bar-mode -1)
    (kill-buffer "*scratch*")
    (defalias 'yes-or-no-p 'y-or-n-p)
    (setq inhibit-startup-screen t)
    (setq initial-scratch-message "")

    ;; Configure package.el to use packages installed by Nix
    (require 'package)
    (setq package-archives nil)
    (package-initialize)

    ;; Start magit-status
    (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
    (magit-status)
  '';

in

runCommand "magit" {
  inherit script initel;
  passAsFile = [ "script" "initel" ];
} ''
  mkdir -p $out/bin
  substitute $scriptPath $out/bin/magit --subst-var out
  chmod +x $out/bin/magit
  cp $initelPath $out/init.el
''
