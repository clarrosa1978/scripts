import paramiko

def check_password(server_ip, server_port, username, password):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Attempt to connect to the remote server
        client.connect(server_ip, port=22, username=username, password=password)
        print("Password is correct!")
        client.close()
    except paramiko.AuthenticationException:
        print("Password is incorrect!")
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
server_ip = "192.168.1.1"  # Replace with your server's IP address
server_port = 22            # Replace with your server's SSH port if different
username = "root"           # Replace with the username you want to check
password = "123456"       # Replace with the password you want to check

check_password(server_ip, server_port, username, password)
