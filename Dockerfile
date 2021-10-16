FROM gcr.io/google-appengine/python

# Create a virtualenv for dependencies. This isolates these packages from
# system-level packages.
# Use -p python3 or -p python3.7 to select python version. Default is version 2.
RUN virtualenv -p python3.7 /env

# Setting these environment variables are the same as running
# source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

RUN apt-get update && apt-get install -y \
	vim \
	curl \
	wget \
	git \
	make \
	netcat \
	python \
	python2.7-dev \
	g++ \
	bzip2 \
	binutils

RUN apt-get install -y \
	# libasound2 \
	# libasound-dev \
	# libssl-dev \
    portaudio19-dev

# Copy the application's requirements.txt and run pip to install all
# dependencies into the virtualenv.
ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

# Add the application source code.
ADD . /app

# Run a WSGI server to serve the application. gunicorn must be declared as
# a dependency in requirements.txt.
CMD gunicorn -b :$PORT main:app
