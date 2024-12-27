import argparse
import paramiko

def check_password(hosts, username, password):
    for server_ip in hosts:
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

            # Attempt to connect to the remote server
            client.connect(server_ip, port=22, username=username, password=password, timeout=3)
            print(f"Password is correct for {server_ip}!")
            client.close()
        except paramiko.AuthenticationException:
            print(f"Password is incorrect for {server_ip}!")
        except Exception as e:
            print(f"An error occurred with {server_ip}: {e}")

def main():
    parser = argparse.ArgumentParser(description="Check password on remote Linux servers")
    parser.add_argument("hosts", metavar="H", type=str, nargs="+", help="List of host IP addresses")
    parser.add_argument("--username", required=True, help="Username to check")
    parser.add_argument("--password", required=True, help="Password to check")

    args = parser.parse_args()
    check_password(args.hosts, args.username, args.password)

if __name__ == "__main__":
    main()

