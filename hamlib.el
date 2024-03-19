(setq hamlib-rigctl-command "rigctl") 
(setq hamlib-rigctl-rigfile "192.168.1.12:4532")
(setq hamlib-rigctl-model "2")

(defun rigctl (cmd param)
  "Send command to rigctl"
  (interactive)
  (shell-command-to-string (concat "echo $(" hamlib-rigctl-command " --model=" hamlib-rigctl-model " --rig-file=" hamlib-rigctl-rigfile " " cmd " " param ")")))

(defun rig-get-frequency ()
  "Get the radio's current frequency"
  (interactive)
  (message "%s" (car (split-string (rigctl "f" nil) "\n"))))

(defun rig-set-frequency (freq)
  "Set the radio's current frequency"
  (interactive "NSet frequency: ")
  (rigctl "F" (number-to-string freq))
  (rig-get-frequency))

(defun rig-get-mode ()
  "Get the radio's current mode"
  (interactive)
  (message "%s" (car (split-string (rigctl "m" nil) " "))))

(defun rig-set-mode ()
  "Set the radio's mode"
  (interactive)
  (let (cmd choice)
    (setq choice (completing-read
		  "Modulation mode: " '("USB" "LSB" "CW" "AM" "FM" "PKTLSB" "PKTUSB")))
    (rigctl "M" (concat choice " 0"))
    (rig-get-mode)))

(defun rig-get-vfo ()
  "Get the radio's active VFO" 
  (interactive)
  (message "%s" (rigctl "v" nil)))

(defun rig-set-vfo ()
  "Select the radio's current VFO"
  (interactive)
  (let (cmd choice)
    (setq choice (completing-read
		  "Select VFO: " '("VFOA" "VFOB" "MEM")))
    (rigctl "V" choice)
    (rig-get-vfo)))

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
  (rigctl "L AF" (number-to-string (/ volume 100.0)))
  (message "AF gain set to %s" (rig-get-af)))

(defun rig-get-rf ()
  "Get the radio's radio frequency gain"
  (interactive)
  (message "%d" (* 100 (string-to-number (rigctl "l RF" nil)))))

(defun rig-get-squelch ()
  "Get the radio's squelch level"
  (interactive)
  (message "%d" (* 100 (string-to-number (rigctl "l SQL" nil)))))

(defun rig-get-if ()
  "Get the radio's IF level"
  (interactive)
  (message "%s hz" (rigctl "l IF" nil)))

(defun rig-get-cwpitch ()
  "Get the radio's CW pitch"
  (interactive)
  (message "%s" (rigctl "l CWPITCH" nil)))

(defun rig-get-rf-power ()
  "Get the radio's RF power"
  (interactive)
  (message "%s watts" (* 100 (string-to-number (rigctl "l RFPOWER" nil)))))

(defun rig-get-mic-gain ()
  "Get the radio's microphone gain"
  (interactive)
  (message "%s" (round (* 100 (string-to-number (rigctl "l MICGAIN" nil))))))

(defun rig-get-key-speed ()
  "Get the radio's morse key speed"
  (interactive)
  (message "%s WPM" (rigctl "l KEYSPD" nil)))

(defun rig-get-agc  ()
  "Get the radio's AGC (automatic gain control) status"
  (interactive)
  (setq p1 (rigctl "l AGC" nil))
  (cond
   ((equal p1 "0")
    (setq p1 "Off"))
   ((equal p1 "1")
    (setq p1 "Super fast"))
   ((equal p1 "2")
    (setq p1 "Fast"))
   ((equal p1 "3")
    (setq p1 "Slow"))
   ((equal p1 "4")
    (setq p1 "User"))
   ((equal p1 "5")
    (setq p1 "Medium"))
   ((equal p1 "6")
    (setq p1 "Auto")))
  (message "AGD set as %s" p1))

(defun rig-get-swr ()
  "Get the radio's current SWR (Standing wave ratio)"
  (interactive)
  (message "SWR %d" (string-to-number (s-left 4 (rigctl "l SWR" nil)))))

(defun rig-get-alc ()
  "Get the radio's current ALC level (Automatic Level Control)"
  (interactive)
  (message "ALC %d" (* 100 (string-to-number (rigctl "l ALC" nil)))))

(defun rig-get-signal-strength ()
  (interactive)
  "Get the radio's current signal strength"
  (message "Signal %s dB" (rigctl "l STRENGTH" nil)))

(defun rig-get-power-level ()
  (interactive)
  "Get the radio's current power level"
  (message "%d" (* 100 (string-to-number (rigctl "l RFPOWER_METER" nil)))))
