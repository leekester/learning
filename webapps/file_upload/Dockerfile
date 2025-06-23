# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
# --no-cache-dir reduces image size
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code (app.py and templates folder)
COPY . .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run the application using Gunicorn. This is a production-grade server.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]