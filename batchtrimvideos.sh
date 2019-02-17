#!/bin/bash

for f in *.mp4; do
    duration=$(ffmpeg -i "$f" 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,//)

    length=$(echo "$duration" | awk '{ split($1, A, ":"); print 3600*A[1] + 60*A[2] + A[3] }' )
    # uses the duration variable, spit it at the colon, store the elements
    # after split into a new variable A, prints out the total as measured
    # in seconds, the dollar sign after the equal sign makes the result of
    # the commands in () a new variable

    trim_start=35
    # Change this to the leading time you want

    trim_end=0
    # Change this to how much you want to delete in the end

    final_length=$(echo "$length" - “$trim_end" - "$trim_start" | bc)

    echo ffmpeg -ss "$trim_start" -i "$f" -c copy -map 0 -t "$final_length" "${f%.mp4}-trimmed.mp4"
    # -ss
    # sets the start time
    #
    # -c copy -map 0
    # copy all video, audio and subtitle streams from the original
    # to the cut version
    #
    # -t
    # sets the end time

done