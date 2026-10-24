FROM python:3.11-slim
WORKDIR /app
RUN pip install --no-cache-dir flask
COPY service.py .
ENV PORT=5001
EXPOSE 5001
CMD ["python", "service.py"]
