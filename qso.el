 (require 'widget)

     (eval-when-compile
       (require 'wid-edit))

     (defvar widget-example-repeat)

     (defun QSO-new ()
       "Enter a new QSO."
       (interactive)
       (switch-to-buffer "*New QSO*")
       (kill-all-local-variables)
       (make-local-variable 'widget-example-repeat)
       (let ((inhibit-read-only t))
         (erase-buffer))
       (remove-overlays)
       (widget-insert "Enter the new QSO information.\n\n")
       (widget-create 'editable-field
                      :size 13
		      :help-echo "Enter the callsign"
                      :format "Call: %v ")
       (widget-create 'editable-field
		      :size 13
		      :format "Frequency: %v "
		      :help-echo "Enter the frequency"
		      (rig-get-frequency))
       (widget-create 'menu-choice
		      :size 13
		      :tag "Mode"
		      :value (rig-get-mode)
		      :help-echo "Choose modulation mode"
		      :notify (lambda (widget &rest ignore)
				(message "%s is a good choice!"
					 (widget-value widget)))
		      '(item :tag "FM" :value "FM")
		      '(item :tag "AM" :value "AM")
		      '(item :tag "USB" :value "USB")
		      '(item :tag "LSB" :value "LSB")
		      '(item :tag "CW" :value "CW")
		      '(item :tag "PKTLSB" :value "PKTLSB")
		      '(item :tag "PKTUSB" :value "PKTUSB"))
       (widget-create 'editable-field
		      :size 13
                      :format "RST Sent: %v "
		      :help-echo "Enter the Readability, Strength and Tone sent"
                      "59")
       (widget-create 'editable-field
		      :size 13
                      :format "RST Rcvd: %v "
		      :help-echo "Enter the Readability, Strength and Tone recieved"
                      "59")
       (widget-create 'editable-field
		      :size 13
		      :help-echo "Enter the name of the operator"
		      :format "\nName: %v ")
       (widget-create 'editable-field
		      :size 13
		      :help-echo "Enter the QTH of the operator"
		      :format "QTH: %v ")
       (widget-create 'editable-field
		      :help-echo "Edit the grid reference"
		      :size 13
		      :format "Grid: %v ")
       (widget-create 'editable-field
		      :help-echo "Enter the power output of your transmitter"
		      :size 13
		      :format "Power: %v "
		      (rig-get-power-level))
       (widget-create 'editable-field
		      :help-echo "Date of QSO"
		      :size 13
		      :format "\n\nDate: %v "
		      (format-time-string "%Y-%m-%d" (current-time) t))
       (widget-create 'editable-field
		      :help-echo "Start time of QSO"
		      :size 13
		      :format "Start time: %v "
		      (format-time-string "%H:%M" (current-time) t))
       (widget-create 'editable-field
		      :help-echo "End time of QSO"
		      :size 13
		      :format "End time: %v "
		      (format-time-string "%H:%M" (current-time) t))
       (widget-create 'editable-field
		      :help-echo "Enter any comments here"
		      :size 13
		      :format "\n\nComment: %v ")
       (widget-insert "\n\n")
       (widget-create 'push-button
                      :notify (lambda (&rest ignore)
                                (if (= (length
                                        (widget-value widget-example-repeat))
                                       3)
                                    (message "Congratulation!")
                                  (error "Three was the count!")))
                      "Apply Form")
       (widget-insert " ")
       (widget-create 'push-button
                      :notify (lambda (&rest ignore)
                                (widget-example))
                      "Reset Form")
       (widget-insert "\n")
       (use-local-map widget-keymap)
       (widget-setup))

