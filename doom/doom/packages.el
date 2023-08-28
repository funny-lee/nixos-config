;;; Package --- Summary
;;; Commentary:
;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
;;; Code:

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

(package! crux
  :recipe (:host github :repo "bbatsov/crux"))

(package! rotate
  :recipe (:host github :repo "daichirata/emacs-rotate"))

(package! easy-kill
  :recipe (:host github :repo "leoliu/easy-kill"))

(package! smart-region
  :recipe (:host github :repo "uk-ar/smart-region"))

(package! avy-zap
  :recipe (:host github :repo "cute-jumper/avy-zap"))

(package! iedit
  :recipe (:host github :repo "victorhge/iedit"))

(package! fanyi
  :recipe (:host github :repo "condy0919/fanyi.el"))

(package! ialign
  :recipe (:host github :repo "mkcms/interactive-align"))

(package! goto-last-change)
  ;; :recipe (:host github :repo "camdez/goto-last-change"))

(package! ctrlf)

(package! deadgrep)

(package! nixpkgs-fmt
  :recipe (:host github :repo "purcell/emacs-nixpkgs-fmt"))


;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)
