function repeat_key_toggle
    set VAR __repeat_key_is_running
    set KEY 17 # , in dvorak

    if test $$VAR -gt 0
        set -U $VAR 0
    else
        set -U $VAR 1

        ydotool key $KEY:1 $KEY:0

        while test $$VAR -gt 0
            sleep 0.25

            # check again after the sleep
            if test $$VAR -gt 0
                ydotool key $KEY:1 $KEY:0
            end
        end
    end
end
