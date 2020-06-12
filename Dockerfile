FROM openjdk:8u252 as builder

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && apt-get -y install \
	apt-utils \
	net-tools \
	apt-transport-https \
	wget \
	curl \
	nginx \
	git \
	maven \
 && rm -rf /var/lib/apt/lists/*

COPY / /sagemaker-sparkml-model-server
WORKDIR /sagemaker-sparkml-model-server

RUN mvn clean package



FROM openjdk:8u252

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && apt-get -y install \
	apt-utils \
	net-tools \
	apt-transport-https \
	wget \
	curl \
	nginx \
	git \
 && rm -rf /var/lib/apt/lists/*

COPY   --from=builder /sagemaker-sparkml-model-server/target/sparkml-serving-2.4.3.jar /usr/local/lib/sparkml-serving-2.4.3.jar
COPY   --from=builder /sagemaker-sparkml-model-server/serve.sh /usr/local/bin/serve.sh

RUN chmod a+x /usr/local/bin/serve.sh
ENTRYPOINT ["/usr/local/bin/serve.sh"]
