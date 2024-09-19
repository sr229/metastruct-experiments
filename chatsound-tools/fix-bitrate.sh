#!/bin/bash
# You can convert this to also convert any MP3 to OGG
# But this is intended mostly to fix OGGs with non-compliant bitrates

if [ ! -d "conv/"  ] then
  mkdir conv
fi

for file in *.ogg
  do ffmpeg -i "${file}" -af "aformat=sample_fmts=s16:sample_rates=44100" -acodec libvorbis "conv/${file%.ogg}.ogg"
done