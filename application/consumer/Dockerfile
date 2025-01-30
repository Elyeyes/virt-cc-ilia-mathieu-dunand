FROM python:3.10-slim
WORKDIR /consumer
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "-u", "consumer.py"]
