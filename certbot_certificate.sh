#!/bin/bash
# Automated Certbot Installation Script
# Detects Linux distribution and installs certbot with Apache integration
# Supports Fedora/RHEL/CentOS, Ubuntu/Kubuntu, and Debian
# Written by uriah - 08/02/2026

set -e  # Exit on any error

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_message $RED "Error: This script must be run as root (use sudo)"
    exit 1
fi

print_message $GREEN "=== Certbot Installation Script ==="
echo ""

# Get distribution name from user
while true; do
    read -p "Please provide your Linux Distro name (fedora/ubuntu/debian/centos/rhel): " DISTRO
    # Convert to lowercase for comparison
    DISTRO=$(echo "$DISTRO" | tr '[:upper:]' '[:lower:]' | xargs)
    
    # Validate distro input
    if [[ "$DISTRO" =~ ^(fedora|ubuntu|debian|centos|rhel|red\ hat|kubuntu)$ ]]; then
        print_message $GREEN "Distribution recognized: $DISTRO"
        break
    else
        print_message $RED "Unsupported or invalid distribution. Please try again."
        echo "Supported: fedora, ubuntu, debian, centos, rhel, kubuntu"
    fi
done

echo ""

# Capture domain name and verify user input
while true; do
    read -p "Please enter your Domain name (e.g., example.com or www.example.com): " DOMAIN
    
    # Basic domain validation
    if [[ ! "$DOMAIN" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z]{2,})+$ ]]; then
        print_message $RED "Invalid domain format. Please try again."
        continue
    fi
    
    echo ""
    print_message $YELLOW "Domain name captured as: $DOMAIN"
    
    while true; do
        read -p "Are you sure you want to use this domain? (yes/no): " ANSWER
        ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
        
        if [ "$ANSWER" = "yes" ] || [ "$ANSWER" = "y" ]; then
            print_message $GREEN "Confirmed. Using domain name: $DOMAIN"
            break 2  # Break out of both loops
        elif [ "$ANSWER" = "no" ] || [ "$ANSWER" = "n" ]; then
            print_message $YELLOW "Re-entering domain name..."
            break  # Break inner loop, continue outer loop
        else 
            print_message $RED "Invalid input. Please enter 'yes' or 'no'."
        fi
    done
done

echo ""

# Assigning distribution families
fedora_based=("fedora" "red hat" "centos" "rhel")
ubuntu_based=("ubuntu" "kubuntu")
debian_based=("debian")

# Function to install certbot on Fedora/RHEL/CentOS
install_fedora() {
    print_message $GREEN "Installing certbot for Fedora/RHEL/CentOS..."
    
    # Check if httpd is installed
    if ! command -v httpd &> /dev/null; then
        print_message $YELLOW "Apache (httpd) not found. Installing..."
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
    fi
    
    # Install certbot
    yum install -y certbot python3-certbot-apache
    
    print_message $GREEN "Certbot installed successfully!"
    echo ""
    
    # Ask user which method they prefer
    print_message $YELLOW "Choose certificate installation method:"
    echo "1) Automatic Apache configuration (recommended)"
    echo "2) Manual DNS challenge"
    read -p "Enter choice (1 or 2): " method
    
    case $method in
        1)
            print_message $GREEN "Running automatic Apache configuration..."
            certbot --apache -d "$DOMAIN"
            ;;
        2)
            print_message $GREEN "Running manual DNS challenge..."
            certbot certonly --manual --preferred-challenges dns -d "$DOMAIN"
            ;;
        *)
            print_message $RED "Invalid choice. Defaulting to automatic configuration..."
            certbot --apache -d "$DOMAIN"
            ;;
    esac
}

# Function to install certbot on Ubuntu/Kubuntu
install_ubuntu() {
    print_message $GREEN "Installing certbot for Ubuntu/Kubuntu..."
    
    # Check if apache2 is installed
    if ! command -v apache2 &> /dev/null; then
        print_message $YELLOW "Apache2 not found. Installing..."
        apt update
        apt install -y apache2
        systemctl start apache2
        systemctl enable apache2
    fi
    
    # Install certbot
    apt update
    apt install -y certbot python3-certbot-apache
    
    print_message $GREEN "Certbot installed successfully!"
    echo ""
    
    # Ask user which method they prefer
    print_message $YELLOW "Choose certificate installation method:"
    echo "1) Automatic Apache configuration (recommended)"
    echo "2) Manual DNS challenge"
    read -p "Enter choice (1 or 2): " method
    
    case $method in
        1)
            print_message $GREEN "Running automatic Apache configuration..."
            certbot --apache -d "$DOMAIN"
            ;;
        2)
            print_message $GREEN "Running manual DNS challenge..."
            certbot certonly --manual --preferred-challenges dns -d "$DOMAIN"
            ;;
        *)
            print_message $RED "Invalid choice. Defaulting to automatic configuration..."
            certbot --apache -d "$DOMAIN"
            ;;
    esac
}

# Function to install certbot on Debian
install_debian() {
    print_message $GREEN "Installing certbot for Debian..."
    
    # Check if apache2 is installed
    if ! command -v apache2 &> /dev/null; then
        print_message $YELLOW "Apache2 not found. Installing..."
        apt update
        apt install -y apache2
        systemctl start apache2
        systemctl enable apache2
    fi
    
    # Install certbot
    apt update
    apt install -y certbot python3-certbot-apache
    
    print_message $GREEN "Certbot installed successfully!"
    echo ""
    
    # Ask user which method they prefer
    print_message $YELLOW "Choose certificate installation method:"
    echo "1) Automatic Apache configuration (recommended)"
    echo "2) Manual DNS challenge"
    read -p "Enter choice (1 or 2): " method
    
    case $method in
        1)
            print_message $GREEN "Running automatic Apache configuration..."
            certbot --apache -d "$DOMAIN"
            ;;
        2)
            print_message $GREEN "Running manual DNS challenge..."
            certbot certonly --manual --preferred-challenges dns -d "$DOMAIN"
            ;;
        *)
            print_message $RED "Invalid choice. Defaulting to automatic configuration..."
            certbot --apache -d "$DOMAIN"
            ;;
    esac
}

# Determine distribution family and install
if [[ " ${fedora_based[@]} " =~ " ${DISTRO} " ]]; then
    install_fedora
elif [[ " ${ubuntu_based[@]} " =~ " ${DISTRO} " ]]; then
    install_ubuntu
elif [[ " ${debian_based[@]} " =~ " ${DISTRO} " ]]; then
    install_debian
else
    print_message $RED "Error: Unsupported distribution '$DISTRO'"
    exit 1
fi

echo ""
print_message $GREEN "=== Installation Complete ==="
print_message $GREEN "Your SSL certificate has been installed for domain: $DOMAIN"
echo ""
print_message $YELLOW "Important notes:"
echo "• Certificates auto-renew via systemd timer"
echo "• Check renewal status: certbot renew --dry-run"
echo "• View certificates: certbot certificates"
echo "• Make sure port 443 is open in your firewall"
echo ""
print_message $GREEN "Done!"
