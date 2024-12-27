import paramiko
import argparse

def change_password(server_ip, username, old_password, new_password, timeout=10):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Connect to the remote server
        client.connect(server_ip, username=username, password=old_password, timeout=timeout)

        # Use sudo to change the password
        command = f'echo "{username}:{new_password}" | sudo chpasswd'
        stdin, stdout, stderr = client.exec_command(command)

        # Provide the sudo password
        stdin.write(old_password + '\n')
        stdin.flush()

        # Print any output or errors
        output = stdout.read().decode()
        error = stderr.read().decode()

        if error:
            print(f"Failed to change password for {username} on {server_ip}: {error}")
        else:
            print(f"Password successfully changed for {username} on {server_ip}")

        client.close()
    except paramiko.AuthenticationException:
        print(f"Authentication failed for {username} on {server_ip}!")
    except Exception as e:
        print(f"An error occurred with {server_ip}: {e}")

def main():
    parser = argparse.ArgumentParser(description="Change user password on remote Linux servers")
    parser.add_argument("hosts", metavar="H", type=str, nargs="+", help="List of host IP addresses")
    parser.add_argument("--username", required=True, help="Username to change password for")
    parser.add_argument("--old_password", required=True, help="Current password")
    parser.add_argument("--new_password", required=True, help="New password")
    parser.add_argument("--timeout", type=int, default=10, help="Timeout for SSH connection in seconds")

    args = parser.parse_args()
    for host in args.hosts:
        change_password(host, args.username, args.old_password, args.new_password, args.timeout)

if __name__ == "__main__":
    main()
