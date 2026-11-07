set -l md_files *.md
if test "$md_files" = "*.md"
    echo "No markdown files found."
    return 0
end

# Step 1: Convert each markdown file
for f in $md_files
    set -l org_file (string replace -r '\.md$' '.org' "$f")
    pandoc "$f" -f markdown-yaml_metadata_block -t org -o "$org_file"
    if test $status -ne 0
        echo "Error: Pandoc failed to convert $f"
        return 1
    end
end

# Step 2: Verify every .md file has a matching .org file
for f in $md_files
    set -l org_file (string replace -r '\.md$' '.org' "$f")
    if not test -f "$org_file"
        echo "Error: Missing converted file for $f"
        return 1
    end
end

# Step 3: Copy all .org files to destination
mkdir -p ~/Notes/Org
cp *.org ~/Notes/Org/
if test $status -ne 0
    echo "Error: Failed to copy .org files to ~/Notes/Org"
    return 1
end

# Step 4: Cleanup source files
rm -f $md_files *.org
echo "Successfully converted, copied, and cleaned workspace."
