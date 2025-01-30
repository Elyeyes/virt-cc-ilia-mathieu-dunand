FROM rabbitmq:3.8-management
# Install Python
RUN apt-get update && apt-get install -y python3 python3-pip
WORKDIR /application/consumer
COPY . .
RUN pip install -r requirements.txt
CMD ["python3", "consumer.py"]