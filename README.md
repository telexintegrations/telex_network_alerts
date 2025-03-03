# Network Downtime Alerts

## Overview
This application monitors network connectivity by periodically checking the availability of a specified target URL. It sends real-time alerts to Telex if the connection fails, ensuring prompt awareness of network downtime.

## Features
- Periodically checks server or endpoint availability.
- Sends real-time alerts to Telex on downtime.
- Configurable check interval via Cron expression.
- Lightweight solution without a database.

## Requirements
- Python 3.8+
- Django
- `requests` library
- A valid Telex webhook URL

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/network-downtime-alerts.git
   cd network-downtime-alerts
   ```
2. Create and activate a virtual environment:
   ```sh
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```
3. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```
4. Configure environment variables in `.env`:
   ```env
   TARGET_URL=https://your-server-url.com
   TELEX_WEBHOOK_URL=https://your-telex-webhook-url.com
   ```
5. Run the Django development server:
   ```sh
   python manage.py runserver
   ```

## API Endpoints
### 1. Check Network Status
- **Endpoint:** `/alerts/check/`
- **Methods:** `GET`, `POST`
- **Description:** Checks connectivity to the target URL and updates the status.
- **Response:**
  ```json
  { "status": "up", "message": "Reached https://your-server-url.com" }
  ```

### 2. Handle Telex JSON
- **Endpoint:** `/alerts/integration.json`
- **Methods:** `GET`
- **Description:** Returns JSON metadata for Telex integration.

### 3. Configure Webhook
- **Endpoint:** `/alerts/configure/`
- **Methods:** `POST`
- **Description:** Allows dynamic configuration of the target URL.
- **Request Body:**
  ```json
  { "target_url": "https://new-server-url.com" }
  ```
- **Response:**
  ```json
  { "status": "success", "message": "Target URL configured successfully" }
  ```

### 4. Interval Settings for Cron Job
- **Cron Job Endpoint:** `/tick/`
- **Methods:** `GET`
- **Description:** Triggers the `check_network_status` function at defined intervals using a cron job.
- **Functionality:** The cron job will call this endpoint based on the specified schedule to ensure periodic network status checks.
- **Implementation:** The `/tick/` endpoint executes `check_network_status`, ensuring continuous monitoring. The cron job should be configured to hit this endpoint at the desired interval to automate the network status verification process.

## Testing the Integration
To test the integration, you can use **Postman** or `curl` to send requests to the API endpoints:

### Using Postman:
1. **Open Postman** and create a new request.
2. **Select `POST`** as the request type.
3. **Enter the URL**:
   ```
   https://telex-network-alerts.onrender.com/alerts/configure/
   ```
4. **Go to the "Headers" tab** and add:
   - **Key:** `Content-Type`
   - **Value:** `application/json`
5. **Go to the "Body" tab**:
   - Select **raw**
   - Choose **JSON**
   - Enter the following JSON data:
     ```json
     {
       "target_url": "https://example.com"
     }
     ```
6. **Click "Send"** to execute the request.
7. **Expected Response:**
   ```json
   {
     "status": "success",
     "message": "Target URL configured successfully"
   }
   ```

### Using `curl`:
To test using `curl`, run the following command:
```sh
curl -X POST "https://telex-network-alerts.onrender.com/alerts/configure/" \
     -H "Content-Type: application/json" \
     -d '{"target_url": "https://example.com"}'
```

### Checking Network Status
To manually check the network status, send a `GET` request to:
```sh
curl -X GET "https://telex-network-alerts.onrender.com/alerts/check/"
```
**Expected Response:**
```json
{
  "status": "up",
  "message": "Reached https://your-server-url.com"
}
```

## Deployment
For production deployment, configure a WSGI server like Gunicorn:
```sh
pip install gunicorn
```
Run the server:
```sh
gunicorn --bind 0.0.0.0:8000 project.wsgi:application
```

## Author
- **Name:** Bobbysam
- **Category:** Monitoring & Logging

