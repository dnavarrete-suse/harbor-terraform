# Terraform to install Harbor on DigitalOcean

Terraform will just create an Ubuntu droplet and a DNS record. 

A script will run to install everything needed. Including certificates for Harbor using certbot. 

After around 5-10 min. harbor will be available at harbor-{suffix-from-terraform-tf-vars}.{digital-ocean-domain} . The harbor containers may take up to 5min. to work properly, if you see everything running and without errors, be patient.


## Installation

Fill the variables under terraform.tfvars. If the email is invalid, certbot will fail.

Then just use it as a normal Terraform project
```bash
  terraform init
  terraform apply -auto-approve
```

## Troubleshooting

In case of any issues, the install script will not provide output, so you might want to SSH into the droplet (You can include into your .ssh/config the ssh_config file generated) to check the following:

- Docker was installed successfully. You can see it by running a sample command
```bash
docker ps
```

- Certbot generated the certificates. Check if they are located in the corresponding folder:
```bash
ls -lrt /etc/letsencrypt/live
```

If they were not generated, try running the command and check what the issue might be:
```bash
sudo certbot certonly --non-interactive --standalone -d ${dns_record} --agree-tos -m ${email}
```

- Harbor tgz archive is downloaded correctly:
```bash
ls -lrt /opt/harbor
```

If the archive is empty, the call to https://api.github.com/repos/goharbor/harbor/releases/latest might have been rate limited. You will need to download the contents to a file manually, and execute the following:
```bash
cat downloaded_content.txt \
| grep "browser_download_url.*harbor-offline-installer.*.tgz\"" \
| tail -n 1 \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -O harbor-offline-installer.tgz -qi -
```

Aftwerwards, proceed with the installation

- Harbor doesn't come up

Check the docker container logs and be patient. 
