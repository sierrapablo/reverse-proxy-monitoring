*Project from [roadmap.sh](https://roadmap.sh/projects/monitoring)*

---

# Monitoring for Nginx Reverse Proxy in Docker with HTTPS, Prometheus, Grafana, and Nginx Exporter

This project sets up an **Nginx reverse proxy** deployed in **Docker**, enables **HTTPS** for the proxy, and provides access to **Prometheus** and **Grafana** services on subdomains. It also includes the use of **Nginx Exporter** (in a Docker container) to collect Nginx metrics and a **basic authentication** service for accessing Prometheus.

## Requirements

- **Docker** and **Docker Compose** installed.
- **SSL certificates** to enable HTTPS. These certificates must be stored in the `ssl/` folder, which should be created beforehand.
- Basic knowledge of **Prometheus**, **Grafana**, and **Nginx**.
- A server with **apt** access to install `htpasswd` and create a password file for Nginx.

## Project Structure

The project includes the following components:

- **Nginx**: Acts as a reverse proxy and handles HTTPS traffic.
- **Prometheus**: Used to collect and store metrics from the system and services.
- **Grafana**: Provides a way to visualize the metrics collected by Prometheus.
- **Nginx Exporter**: Collects metrics about the Nginx server itself.
- **htpasswd**: Provides basic authentication to protect access to Prometheus.

## Configuration

### 1. **Prepare the Environment**

- Create the `ssl/` folder in the root directory of the project to store the SSL certificates (e.g., `fullchain.pem` and `server.key`).

```bash
mkdir ssl
```

- Place your SSL certificate files in this folder.

### 2. **Configure Environment Variables**

The `.env.example` file contains the necessary environment variables for the configuration. Modify this file with the appropriate values and rename it to `.env`:

```bash
cp .env.example .env
```

Make sure to fill in the following fields in the `.env` file:

- `GRAFANA_HOST`: The domain for Grafana (e.g., `grafana.yourdomain.com`).
- `PROMETHEUS_HOST`: The domain for Prometheus (e.g., `prometheus.yourdomain.com`).
- `SSL_CERTIFICATE`: The path to the SSL certificate file.
- `SSL_CERTIFICATE_KEY`: The path to the SSL certificate key file.
- `GRAFANA_SECURITY_ADMIN_USER`: The username to access Grafana.
- `GRAFANA_SECURITY_ADMIN_PASSWORD`: The password to access Grafana.

### 3. **Configure Basic Authentication for Prometheus**

Access to Prometheus will be protected via basic authentication. **htpasswd** is used to create a password file for restricting access.

#### 3.1 **Install htpasswd**

If **htpasswd** is not installed, you can install it on your server with **apt**. On a Debian/Ubuntu-based distribution, use the following command:

```bash
sudo apt install apache2-utils
```

#### 3.2 **Create the `.htpasswd` File**

In the root directory of your project, create an `.htpasswd` file that contains the credentials for accessing Prometheus. You can generate it with the following command:

```bash
htpasswd -c .htpasswd <username>
```

This will prompt you to enter a password for the specified username. **This file will be used by Nginx to authenticate users before they can access Prometheus.**

### 4. **Start and Run the Services with Docker Compose**

Once you've configured the environment variables and placed the SSL certificates, you can start the services using Docker Compose. Run the following command to bring up all the containers:

```bash
docker-compose up -d --build
```

This will start the following services:

- **Nginx**: Listening on port 443 with HTTPS enabled, serving Prometheus and Grafana on the configured subdomains.
- **Prometheus**: Listening on port 9090 for metric collection.
- **Grafana**: Listening on port 3000 for metric visualization.
- **Nginx Exporter**: Collecting Nginx metrics and exposing them to Prometheus.

### 5. **Access the Services**

- **Prometheus**: [https://prometheus.yourdomain.com](https://prometheus.yourdomain.com) (requires basic authentication)
- **Grafana**: [https://grafana.yourdomain.com](https://grafana.yourdomain.com)
  - Username: The username configured in `GRAFANA_SECURITY_ADMIN_USER`.
  - Password: The password configured in `GRAFANA_SECURITY_ADMIN_PASSWORD`.

### 6. **Configure Grafana**

Once you access Grafana, you can create dashboards to visualize the metrics collected by Prometheus. You can do this manually or import a pre-configured dashboard using the ID `12708`, which is a popular dashboard for monitoring system and application metrics for a nginx reverse proxy.

- **To import the dashboard**:
  1. Go to Grafana.
  2. In the left menu, select **Dashboards > Manage > Import**.
  3. Enter the ID `12708` in the Dashboard ID field.
  4. Click **Load** and then **Import**.

This will load a pre-configured dashboard with various panels for monitoring common system metrics.

### 7. **Add Custom Panels (Optional)**

If you want to further customize your dashboard, you can create additional panels using PromQL queries to retrieve specific metrics.

## Advanced and Customization

- **Alerts**: If you'd like to add alerts in Prometheus, you can configure alert rules in the Prometheus configuration file.
- **Additional Services**: You can add more exporters to monitor other services or applications in your infrastructure. Make sure those services are connected to the same network as the reverse proxy, prometheus and grafana.

## Conclusion

This project will allow you to set up a full monitoring system for your infrastructure using **Prometheus** and **Grafana**. It also provides an authentication layer via basic authentication for Prometheus, enables HTTPS for the services deployed through **Nginx**, and uses **nginx-exporter** to monitor Nginx itself.

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.
