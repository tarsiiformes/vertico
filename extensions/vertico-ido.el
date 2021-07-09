;;; vertico-ido.el --- Provide Ido-like commands for Vertico -*- lexical-binding: t -*-

;; Copyright (C) 2021  Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package is a Vertico extension, which provides Ido-like
;; commands. The commands can be bound in the `vertico-map'.
;;
;; (define-key vertico-map "\r" #'vertico-ido-exit)
;; (define-key vertico-map "\d" #'vertico-ido-delete)

;;; Code:

(require 'vertico)

(defun vertico-ido--completing-file-p ()
  "Return non-nil when completing file names."
  (eq 'file
      (completion-metadata-get
       (completion-metadata
        (buffer-substring (minibuffer-prompt-end)
                          (max (minibuffer-prompt-end) (point)))
        minibuffer-completion-table
        minibuffer-completion-predicate)
       'category)))

;;;###autoload
(defun vertico-ido-exit ()
  "Exit completion with current candidate or insert directory."
  (interactive)
  (if (and (>= vertico--index 0)
           (string-suffix-p "/" (vertico--candidate))
           (vertico-ido--completing-file-p))
      (vertico-insert)
    (vertico-exit)))

;;;###autoload
(defun vertico-ido-delete ()
  "Delete char before or go up directory for file cagetory selectrum buffers."
  (interactive)
  (if (and (eq (char-before) ?/)
           (vertico-ido--completing-file-p))
      (save-excursion
        (goto-char (1- (point)))
        (when (search-backward "/" (point-min) t)
          (delete-region (1+ (point)) (point-max))))
    (call-interactively 'backward-delete-char)))

(provide 'vertico-ido)
;;; vertico-ido.el ends here
