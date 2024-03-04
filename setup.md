
 - Initial password will be emailed
 - Log into the console
   - change password is forced
   - set new password in secrets manager at `<<env>>/css/password`
 - Go to Access Management -> Manage users
   - enable API access for the admin user
 - Go to Configuration -> API Agent Settings
   - add New Region `eu-west-2`
   - choose the main VPC
   - choose public subnets for LB and Agent
   - 0.0.0.0/0 for the inbound cidr
   - create new certificate
   - min Agents 1, max Agents 12, ClamAV, CPU 2,  Memory 8gb disk 100

 - Test the scanner by getting a token
   - `http --json POST https://<<api url>>/api/Token <<< '{"username": "admin", "password": "<<password>>"}
