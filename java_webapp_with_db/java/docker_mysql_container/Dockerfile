FROM java:8 

MAINTAINER nk

# define the working environment
ENV ITBOX_DATA /projects/itbox/data
ENV ITBOX_SCRIPTS /projects/itbox/scripts
ENV ITBOX_TOOLS /projects/itbox/tools
ENV MAVEN_HOME /opt/apache-maven-3.3.3/
ENV SOURCE $ITBOX_DATA/source
ENV TMP /tmp
ENV JBOSS_HOME /opt/jboss/wildfly
ENV PATH $JBOSS_HOME/bin:$MAVEN_HOME/bin:$PATH

### Begin PART 1: Install Maven & Build my Project ###

# Install maven
#RUN apt-get update
#RUN apt-get install -y maven

RUN cd $TMP
COPY binary_deployables/apache-maven-3.3.3-bin.zip $TMP/
RUN unzip $TMP/apache-maven-3.3.3-bin.zip -d /opt/

RUN mkdir -p "$ITBOX_DATA"
RUN mkdir -p "$ITBOX_SCRIPTS"
RUN mkdir -p "$ITBOX_TOOLS"
RUN mkdir -p "$SOURCE"
RUN mkdir -p "$JBOSS_HOME"

WORKDIR $SOURCE
COPY javaee6angularjsmysql/src $SOURCE/src/
COPY javaee6angularjsmysql/pom.xml $SOURCE/

#RUN ["mvn", "dependency:resolve"]
#RUN ["mvn", "verify"]

RUN ["mvn", "install"]

### End of Part 1 ###

### Begin PART 2: Deploy Binary App & Dependencies ###

RUN cd $TMP

#COPY binary_deployables/wildfly-8.2.1.Final.tar.gz $TMP/

RUN curl -o $TMP/jboss-8.2.1.tar.gz http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz
RUN tar --gunzip -xvf $TMP/jboss-8.2.1.tar.gz -C $JBOSS_HOME --strip 1

WORKDIR $SOURCE

COPY binary_deployables/standalone.xml $JBOSS_HOME/standalone/configuration/
COPY binary_deployables/mysql-connector-java-5.1.31-bin.jar $JBOSS_HOME/standalone/deployments/
COPY binary_deployables/mysql-sample-ds.xml $JBOSS_HOME/standalone/deployments/

RUN cp -p -r $SOURCE/target/javaee6angularjsmysql.war $JBOSS_HOME/standalone/deployments/

EXPOSE 8080

### End of Part 2 ###

### Begin PART 3: Now run the dreaded command(!) ###

#CMD ["standalone.sh", "-b", "0.0.0.0"]
CMD ["standalone.sh", "-c", "standalone-full.xml", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
#CMD ["standalone.sh"]
