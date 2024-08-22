find /sfvcc12 -type f -name "*.log" -mtime +2 -exec gzip -f {} \;
