(local-set-key "k" #'(lambda ()
			(interactive)
			(scroll-down (/ (window-height) 4))))
(local-set-key "j" #'(lambda ()
			(interactive)
			(scroll-up (/ (window-height) 4))))

(provide 'foo-info-mode)

