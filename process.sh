#!/bin/bash

# Run the LLM command and save to temporary markdown
llm "$1" > tmp.md

# Preview the file
cat tmp.md | less

# Ask for confirmation
read -p "Is the document OK? (yes/no): " answer

if [ "$answer" = "yes" ]; then
    # Ask for the desired filename
    read -p "Enter filename (default: file): " filename
    
    # Set default if input is empty
    filename=${filename:-file}
    
    # Convert markdown to typst
    pandoc tmp.md -o "${filename}.typ"
    
    # Remove the temporary file
    rm tmp.md
    echo "Success: ${filename}.typ created and tmp.md removed."
else
    echo "Action cancelled. tmp.md has been kept."
fi
