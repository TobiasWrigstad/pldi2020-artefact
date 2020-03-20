for i in $(seq 1 ${1:-5}); do
  grep -h title ${i}/*/*/*.html | perl -n -e '/: (\d+) .* ; (\d+) / && print $1 . " " . $2. "\n"' > $i.txt
done
