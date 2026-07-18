#!/usr/bin/env python3
import os
import subprocess
import hashlib
import gzip

script_dir = os.path.dirname(os.path.abspath(__file__))
repo_dir = os.path.dirname(script_dir)
packages_dir = os.path.join(repo_dir, "packages")
packages_file_path = os.path.join(repo_dir, "Packages")

if not os.path.exists(packages_dir):
    os.makedirs(packages_dir)

packages_list = []

for filename in os.listdir(packages_dir):
    if not filename.endswith(".deb"):
        continue
    filepath = os.path.join(packages_dir, filename)
    
    # Get file size and hashes
    size = os.path.getsize(filepath)
    with open(filepath, "rb") as f:
        data = f.read()
        md5 = hashlib.md5(data).hexdigest()
        sha1 = hashlib.sha1(data).hexdigest()
        sha256 = hashlib.sha256(data).hexdigest()
        
    # Extract control info using dpkg-deb
    try:
        control_info = subprocess.check_output(
            ["dpkg-deb", "-f", filepath]
        ).decode("utf-8")
    except Exception as e:
        print(f"Error reading {filename}: {e}")
        continue
        
    # Standardize package info format
    info = control_info.strip()
    info += f"\nFilename: packages/{filename}"
    info += f"\nSize: {size}"
    info += f"\nMD5sum: {md5}"
    info += f"\nSHA1: {sha1}"
    info += f"\nSHA256: {sha256}"
    
    packages_list.append(info)

# Write Packages file
with open(packages_file_path, "w") as f:
    f.write("\n\n".join(packages_list) + "\n")

# Compress to Packages.gz
with open(packages_file_path, "rb") as f_in:
    with gzip.open(packages_file_path + ".gz", "wb") as f_out:
        f_out.writelines(f_in)

print("Repository index updated successfully!")
