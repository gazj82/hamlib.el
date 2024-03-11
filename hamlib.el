(setq hamlib-rigctl-command "rigctl") 
(setq hamlib-rigctl-rigfile "192.168.1.12:4532")
(setq hamlib-rigctl-model "2")

(defun rigctl (cmd param)
  "Send command to rigctl"
  (interactive)
  (let (par (number-to-string param))
  (shell-command-to-string (concat "printf %s $(" hamlib-rigctl-command " --model=" hamlib-rigctl-model " --rig-file=" hamlib-rigctl-rigfile " " cmd " " par ")"))))

(defun rig-get-frequency ()
  "Get the radio's current frequency"
  (interactive)
  (message "%s" (rigctl "f" nil)))

(defun rig-get-mode ()
  "Get the radio's current mode"
  (interactive)
  (message "%s" (rigctl "m" nil)))

(defun rig-get-vfo ()
  "Get the radio's active VFO"
  (interactive)
  (message "%s" (rigctl "v" nil)))

(defun rig-get-rit ()
  "Get the radio's RIT (Reciever Incremental Tuning)"
  (interactive)
  (message "%s" (rigctl "j" nil)))

(defun rig-get-xit ()
  "Get the radio's XIT (Transmitter Incremental Tuning)"
  (interactive)
  (message "%s" (rigctl "z" nil)))

(defun rig-get-ptt ()
  "Get the radio's PTT (Push to talk) status"
  (interactive)
  (message "%s" (rigctl "t" nil)))

(defun rig-get-split ()
  "Get the radio's Split VFO status"
  (interactive)
  (if (eq (rigctl "s" nil) '0)
      (message "Normal mode")
    (message "Split mode")))

(defun rig-get-split-frequency ()
  "Get the radio's split TX frequency"
  (interactive)
  (message "%s" (rigctl "i" nil)))

(defun rig-get-split-mode ()
  "Get the radio's split mode"
  (interactive)
  (message "%s" (rigctl "x" nil)))

(defun rig-get-powerstatus ()
  "Get the radio's power status"
  (interactive)
  (if (equal (rigctl "get_powerstat" nil) "1")
      (message "Radio is powered ON!")
    (message "Radio is powered OFF!")))

(defun rig-set-powerstatus ()
  "Set the radio's power status"
  (interactive)
  (let (cmd choice)
    (setq choice (completing-read
		  "Power radio: " '("ON" "OFF")))
    (if (equal choice "ON")
	(setq p1 "1")
      (setq p1 "0")))
  (rigctl "set_powerstat" p1)
  (rig-get-powerstatus))

(defun rig-get-preamp ()
  "Get the radio's pre-amplifier status"
  (interactive)
  (message (rigctl "l PREAMP" nil)))

(defun rig-get-att ()
  "Get the radio's attenuator status"
  (interactive)
  (message (rigctl "l ATT" nil)))

(defun rig-get-voxdelay ()
  "Get the radio's VOX delay"
  (interactive)
  (message (rigctl "l VOXDELAY" nil)))

(defun rig-get-af ()
  "Get the radio's audio frequency (volume) gain"
  (interactive)
  (message "%d" (* 100 (string-to-number (rigctl "l AF" nil)))))

(defun rig-set-af (volume)
  "Set the radio's audio frequency (volume) gain"
  (interactive "NSet volume: ")
  (rigctl "L AF" 0.2)
  (message "AF gain set to %s" (rig-get-af)))
