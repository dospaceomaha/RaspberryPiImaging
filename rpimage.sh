#!/bin/bash

ls /dev/disk/by-id/ | grep usb-TS-RDF5_SD_Transcend_000000000039-0:0 > /dev/null

if [ "$?" -eq 0 ]; then
        pidof dd > /dev/null
        isrunning="$?"
        if [[ "$isrunning" -ne 0 ]]; then
                if [[ "$1" -eq 1 ]]; then
                        stime=$(date +%s)
                        dd bs=4M of=/home/cit-admin/pibackup2.img if=/dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0 status=progress conv=fsync
                        dtime=$(date +%s)
                        fintime=$((dtime-stime))
                        if (( $fintime < 600 )); then
                                echo $(date) "    $stime - $dtime = $fintime" "    This SD card is bad!    Copy Card" >> /home/cit-admin/rpilog
                        else
                                echo $(date) "    Image Successfull    Time To Read: $fintime" >> /home/cit-admin/rpilog
                        fi
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part1
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part2
                        udisksctl power-off -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0
                else
                        stime=$(date +%s)
                        dd bs=4M if=/home/cit-admin/pibackup2.img of=/dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0 status=progress conv=fsync
                        dtime=$(date +%s)
                        fintime=$((dtime-stime))
                        if (( $fintime < 600 )); then
                                echo $(date) "    $stime - $dtime = $fintime" "    This SD card is bad!    Image Card" >> /home/cit-admin/rpilog
                        else
                                echo $(date) "    Image Successful    Time To Write: $fintime" >> /home/cit-admin/rpilog
                        fi
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part1
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part2
                        udisksctl power-off -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0
                fi
        else
                printf "\nI'm Busy! Come back later.\n"
                exit 1
        fi
elif [ "$?" -ne 0 ]; then
        printf "\nPlease plug the Transcend adapter with SD card in to the computer and try again\n"
