from python:3.10

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 -y

RUN git clone https://github.com/lllyasviel/Fooocus.git /fooocus
WORKDIR /fooocus
RUN pip3 install -r requirements_versions.txt

CMD python3 entry_with_update.py --listen
# PORT 7865
