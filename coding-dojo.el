;;
;; coding-dojo.el
;;
;; Uses copy-directory, from Emacs 23.2
;; See http://github.com/sroccaserra/coding-dojo
;;

;;;
;; Customization

(defgroup coding-dojo nil
  "Customizations for `coding-dojo'. See http://github.com/sroccaserra/coding-dojo")

(defcustom *dojo-template-dir* "~/Developer/coding-dojo/languages"
  "Where your language templates are. The 'languages' direcory that comes with `coding-dojo.el' is a good starting point."
  :group 'coding-dojo
  :type '(directory))
(defcustom *dojo-project-dir* "~/Dropbox/Developer/CodingDojo"
  "Where you want `dojo-new-project' to create your new projects."
  :group 'coding-dojo
  :type '(directory))
(defcustom *dojo-find-command* "find %s -type f"
  "The 'find' command used to list files"
  :group 'coding-dojo
  :type '(string))
(defcustom *dojo-prune-paths* '("*/.git/*" "*/.hg/*")
  "Paths excluded from the file list"
  :group 'coding-dojo
  :type '(repeat string))
(defcustom *dojo-after-new-project-command* ""
  "Example: \"git init && git add . && git commit -m 'first'\""
  :group 'coding-dojo
  :type '(string))

;;;
;; Code

(defstruct dojo-project
  name
  language)

(defun dojo-template-dir (language)
  (concat *dojo-template-dir* "/" language))

(defun dojo-project-dir-for (project)
  (format "%s/%s-%s"
          *dojo-project-dir*
          (upcase-initials (dojo-project-name project))
          (dojo-project-language project)))

(defun dojo-project-exists (project)
  (file-exists-p (dojo-project-dir-for project)))

(defun dojo-create-project (project)
  (let ((project-name (dojo-project-name project))
        (language (dojo-project-language project))
        (project-dir (dojo-project-dir-for project)))
    (when (dojo-project-exists project)
      (error "Project %s in language %s already exists." project-name language))
    (copy-directory (dojo-template-dir language) project-dir)
    project))

(defun dojo-delete-project (project)
  (dired-delete-file (dojo-project-dir-for project) 'always))

(defun dojo-unexpand-home (str)
  (let ((home (shell-command-to-string "echo -n ~")))
    (replace-in-string str home "~")))

(defun dojo-find-project-files (project)
  (let* ((project-dir (dojo-project-dir-for project))
         (find-command (concat (format *dojo-find-command* project-dir)
                               (dojo-prune-arguments *dojo-prune-paths*)))
         (output (shell-command-to-string find-command)))
    (split-string (dojo-unexpand-home output) "\n")))

(defun dojo-find-main-file (project)
  (find-if  (lambda (x)
              (string-match (concat "\\<" (regexp-quote (dojo-project-name project)) "\\.") x))
            (dojo-find-project-files project)))

(defun dojo-find-test-file (project)
  (let ((project-dir (dojo-project-dir-for project)))
    (find-if (lambda (file)
               (string-match (format "%s.*tests?\." project-dir)
                             file))
             (dojo-find-project-files project))))

(defun dojo-prune-arguments (path-patterns)
  (reduce (lambda (x y)
            (concat x " ! -path " (shell-quote-argument y)))
          (push "" path-patterns)))

(defun dojo-substitute-variables (project)
  (let ((project-name (dojo-project-name project))
        (files (dojo-find-project-files project)))
    (labels ((replace-main-in-file
              (file)
              (let ((auto-mode-alist '())) ;; disable modes that could start processes, like flymake mode
                (with-current-buffer (find-file-noselect file t)
                  (unwind-protect
                      (save-current-buffer
                        (goto-char (point-min))
                        (while (search-forward-regexp "xxxx" nil t)
                          (replace-match project-name nil t))
                        (basic-save-buffer))
                    (kill-this-buffer))))))
      (mapcar #'replace-main-in-file files))))

(defun dojo-project-file (main-file project-name)
  (replace-regexp-in-string "\\<xxxx" project-name main-file))

(defun dojo-rename-files (project)
  (let ((project-files (dojo-find-project-files project))
        (project-name (dojo-project-name project)))
    (mapcar (lambda (file)
              (let ((new-name (dojo-project-file file project-name)))
                (unless (equal file new-name)
                  (rename-file file new-name t))))
            project-files)))

(defun dojo-find-languages ()
  (let ((find-command (format "find %s -type d -maxdepth 1 -mindepth 1"
                              *dojo-template-dir*)))
    (split-string (replace-in-string (shell-command-to-string find-command)
                                     ".*/\\|\n^$"
                                     "")
                  "\n")))

(defun valid-haskell-module-p (name)
  (let ((case-fold-search nil)) ;; hello dynamic binding
    (when (string-match-p "[A-Z][:alnum:]*" name)
      t)))

(defun dojo-new-project (project-name language)
  (interactive (let ((languages (mapcar 'downcase (dojo-find-languages))))
                 (list (read-from-minibuffer "Project Name: ")
                       (completing-read "Language: " languages nil t))))
  (let ((project (make-dojo-project :name project-name
                                    :language (upcase-initials language))))
    (when (dojo-project-exists project)
      (if (y-or-n-p "Project %s in language %s already exists, delete it?")
          (dired-delete-file (dojo-project-dir-for project) 'always)
        (error "Project %s in language %s already exists." project-name language)))
    (dojo-create-project project)
    (dojo-substitute-variables project)
    (dojo-rename-files project)
    (unless (eq "" *dojo-after-new-project-command*)
      (save-excursion
        (find-file (dojo-project-dir-for project))
        (shell-command *dojo-after-new-project-command*)
        (kill-buffer)))
    (let ((main-file (dojo-find-main-file project)))
      (when main-file
        (find-file (dojo-project-file main-file project-name))
        (find-file (dojo-find-test-file project))))))

(provide 'coding-dojo)
