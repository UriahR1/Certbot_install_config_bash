# Certbot SSL Certificate Installer

Automated script to install and configure SSL certificates using Let's Encrypt Certbot on Linux servers running Apache.

## Features

- Automatic SSL certificate installation via Let's Encrypt
- Multi-distro support (Fedora, RHEL, CentOS, Ubuntu, Debian)
- Input validation for domain names and distro selection
- Auto-installs Apache if not present
- Color-coded output for better readability
- Choice between automatic Apache config or manual DNS challenge

## Supported Distributions

- **Fedora-based:** Fedora, RHEL, CentOS
- **Debian-based:** Debian, Ubuntu, Kubuntu

## Prerequisites

- Root access (sudo privileges)
- A registered domain name pointing to your server's IP address
- Port 80 (HTTP) open in your firewall
- Port 443 (HTTPS) open in your firewall (for certificate validation)

## Installation

1. Download the script:
```bash
wget https://raw.githubusercontent.com/yourusername/certbot-installer/main/certbot-installer.sh
```

Or clone the repository:
```bash
git clone https://github.com/yourusername/certbot-installer.git
cd certbot-installer
```

2. Make the script executable:
```bash
chmod +x certbot-installer.sh
```

## Usage

Run the script with sudo:
```bash
sudo ./certbot-installer.sh
```

The script will prompt you for:
1. Your Linux distribution name
2. Your domain name (e.g., example.com or www.example.com)
3. Confirmation of the domain
4. Certificate installation method (automatic or DNS challenge)

### Example Session
```
=== Certbot Installation Script ===

Please provide your Linux Distro name (fedora/ubuntu/debian/centos/rhel): ubuntu
Distribution recognized: ubuntu

Please enter your Domain name (e.g., example.com or www.example.com): example.com

Domain name captured as: example.com
Are you sure you want to use this domain? (yes/no): yes
Confirmed. Using domain name: example.com

Installing certbot for Ubuntu/Kubuntu...
...
```

## Post-Installation

After successful installation:

- Your site will be accessible via HTTPS: `https://yourdomain.com`
- Certificates auto-renew via systemd timer
- Check renewal status: `sudo certbot renew --dry-run`
- View installed certificates: `sudo certbot certificates`

## Firewall Configuration

Ensure your firewall allows traffic on ports 80 and 443:

**For UFW (Ubuntu/Debian):**
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
```

**For firewalld (Fedora/RHEL/CentOS):**
```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

**For AWS EC2:**
Add inbound rules to your Security Group:
- Type: HTTP, Port: 80, Source: 0.0.0.0/0
- Type: HTTPS, Port: 443, Source: 0.0.0.0/0

## Certificate Renewal

Certbot automatically sets up certificate renewal. Certificates are valid for 90 days and auto-renew when they have 30 days or less remaining.

Test the renewal process:
```bash
sudo certbot renew --dry-run
```

## Troubleshooting

### Certificate installation fails
- Verify your domain points to your server's IP: `dig yourdomain.com`
- Ensure ports 80 and 443 are open
- Check Apache is running: `sudo systemctl status apache2` or `sudo systemctl status httpd`

### Domain validation errors
- Make sure DNS propagation is complete (can take up to 48 hours)
- Try the DNS challenge method instead of automatic

### Permission errors
- Ensure you're running the script with sudo

## Manual Certificate Management

**Renew certificates manually:**
```bash
sudo certbot renew
```

**Revoke a certificate:**
```bash
sudo certbot revoke --cert-path /etc/letsencrypt/live/yourdomain.com/cert.pem
```

**Delete a certificate:**
```bash
sudo certbot delete --cert-name yourdomain.com
```

## Security Notes

- Let's Encrypt certificates are free and trusted by all major browsers
- Certificates expire after 90 days but renew automatically
- Always keep your server and Certbot updated
- Use strong SSL configurations (the script uses Certbot's defaults which are secure)

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Written by uriah - February 2026

Originally created as practice for AWS Cloud Certification studies.

## Acknowledgments

- Built for Stephane's AWS Cloud Cert tutorial
- Uses Let's Encrypt for free SSL certificates
- Inspired by the need for automated SSL deployment

## Resources

- Let's Encrypt Documentation](https://letsencrypt.org/docs/
- Certbot Documentation](https://eff-certbot.readthedocs.io/
- Apache SSL/TLS Configuration](https://httpd.apache.org/docs/2.4/ssl/

## Changelog

### Version 1.0.0 (2026-02-08)
- Initial release
- Multi-distro support
- Interactive domain validation
- Color-coded output
- Auto Apache installation
