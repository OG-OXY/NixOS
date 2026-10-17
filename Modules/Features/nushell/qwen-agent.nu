#!/usr/bin/env nu

# Final and complete local coding agent runner script for llama.cpp and Qwen
def main [] {
    let api_url = "http://localhost:8080/v1/chat/completions"
    
    # Verify absolute path to avoid subfolder lookup failures
    let key_path = "/home/ty/NixOS/Master/Modules/System/Services/AI/llama-cpp/keys.txt"
    if not ($key_path | path exists) {
        print $"(ansi red_bold)Error: Key file not found at ($key_path)!(ansi reset)"
        return
    }
    let api_key = (open $key_path | str trim)

    print $"(ansi green_bold)Local Qwen Engine Activated. Type 'exit' to quit.(ansi reset)"

    # Store conversation history to maintain chat memory
    mut messages = [
        { role: "system", content: "You are a local developer terminal assistant. When asked to look at files or run commands, output a strict json markdown block tool call. Available tools: read (args: path), write (args: path, content), bash (args: command)." }
    ]

    loop {
        let input = (input "(ansi yellow_bold)user ❯ (ansi reset)")
        if $input == "exit" { break }
        if ($input | str trim | is-empty) { continue }

        $messages = ($messages | append { role: "user", content: $input })

        # Call the local llama.cpp endpoint
        print "(ansi cyan)Thinking...(ansi reset)"
        let payload = {
            model: "qwen-14b"
            messages: $messages
            temperature: 0.1
        }

        let response = (http post --content-type application/json 
            -H [Authorization $"Bearer ($api_key)"] 
            $api_url 
            ($payload | to json)
        )

        let ai_text = $response.choices.0.message.content
        $messages = ($messages | append { role: "assistant", content: $ai_text })

        # Regular Expression to parse and match the JSON tool blocks leaking into the text
        let json_match = ($ai_text | parse --regex '(?s)```json\s*(?<json_block>\{.*?\})\s*```')

        if ($json_match | is-empty) {
            # Standard conversational text response
            print $"\n(ansi green)assistant ❯(ansi reset) ($ai_text)\n"
        } else {
            # Found a text pattern! Parse it into standard structures
            let raw_json = $json_match.0.json_block
            let tool = ($raw_json | from json)
            
            # Check if it's an actual tool dictionary with a 'name' key to prevent crashes
            if ($tool | reflect json | get type) == "record" and "name" in $tool {
                let tool_name = $tool.name
                let tool_args = if "arguments" in $tool { $tool.arguments } else { {} }

                print $"\n(ansi magenta_bold)↺ Tool Intercepted:(ansi reset) ($tool_name)"
      
                # Match tool types and perform structural system operations natively
                match $tool_name {
                    "read" => {
                        let file_path = $tool_args.path
                        print $"(ansi gray)Running: cat ($file_path)(ansi reset)"
                        if ($file_path | path exists) {
                            let content = (open $file_path | into string)
                            print $"\n($content)\n"
                        } else {
                            print $"(ansi red_bold)Error: File ($file_path) not found.(ansi reset)"
                        }
                    }
                    "bash" => {
                        let cmd = $tool_args.command
                        print $"(ansi gray)Running: ($cmd)(ansi reset)"
                        # Securely spin off execution right to your local environment shell
                        nu -c $cmd
                    }
                    "write" => {
                        let file_path = $tool_args.path
                        let content = $tool_args.content
                        print $"(ansi gray)Writing file to ($file_path)(ansi reset)"
                        $content | save -f $file_path
                        print "(ansi green)File updated successfully.(ansi reset)"
                    }
                    _ => {
                        print $"(ansi red_bold)Unknown tool type received: ($tool_name)(ansi reset)"
                    }
                }
            } else {
                # Fallback if Qwen just output generic JSON text that isn't an agent tool structure
                print $"\n(ansi green)assistant ❯(ansi reset) ($ai_text)\n"
            }
        }
    }
}
