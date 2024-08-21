{ if ( NR == 1 && $0 ~ /^[0-9]{12}$/ ) { print $0 }
  if ( NR > 1 && NR < rec_count && $0 ~ /^[0-9]{9}A[ ][ ]$/ ) { print $0 }
  if ( NR == rec_count && $0 ~ /^[0-9][0-9]*[ ]*$/ ) { print $0 }
}
