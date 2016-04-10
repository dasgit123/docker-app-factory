# IMPORTANT REFERENCE

# deploy mysql container

```
docker run --name mysql_db -p 3306:3306 -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql -e MYSQL_DATABASE=sample -e  MYSQL_ROOT_PASSWORD=supersecret -d mysql
```
# make directory & extract the package
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container$ pwd
/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container$ ll
total 973
-rwxrwxrwx    1 docker   staff          318 Feb  6  2015 Dockerfile
drwxrwxrwx    1 docker   staff            0 Oct  8 21:14 javaee6angularjsmysql/
-rwxrwxrwx    1 docker   staff       964882 Feb  6  2015 mysql-connector-java-5.1.31-bin.jar
-rwxrwxrwx    1 docker   staff          493 Oct 11 20:05 mysql-sample-ds.xml
-rwxrwxrwx    1 docker   staff          493 Feb  6  2015 mysql-sample-ds.xml.orig
-rwxrwxrwx    1 docker   staff         9580 Feb  6  2015 readme.md
drwxrwxrwx    1 docker   staff            0 Oct  8 07:25 screenshots/
-rwxrwxrwx    1 docker   staff        19696 Feb  6  2015 standalone.xml

# set the environ paths respectively

docker@default:/c/Users/nk/docker_stuff/tools/jdk1.7.0_79$ export JAVA_HOME=/c/Users/nk/docker_stuff/tools/jdk1.7.0_79
docker@default:/c/Users/nk/docker_stuff/tools/apache-maven-3.3.3$ export MAVEN_HOME=/c/Users/nk/docker_stuff/tools/apache-maven-3.3.3

docker@default:/c/Users/nk/docker_stuff/tools/apache-maven-3.3.3$ export PATH=$PATH:$MAVEN_HOME/bin:$JAVA_HOME/bin
docker@default:/c/Users/nk/docker_stuff/tools/apache-maven-3.3.3$ echo $PATH
/home/docker/.local/bin:/home/docker/.local/bin:/usr/local/sbin:/usr/local/bin:/apps/bin:/usr/sbin:/usr/bin:/sbin:/bin:/c/Users/nk/docker_stuff/tools/apache-maven-3.3.3/bin:/c/Users/nk/docker_stuff/tools/jdk1.7.0_79/bin

docker@default:/c/Users/nk/docker_stuff/tools/apache-maven-3.3.3$ java -version
java version "1.7.0_79"
Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)
docker@default:/c/Users/nk/docker_stuff/tools/apache-maven-3.3.3$ mvn --version
Apache Maven 3.3.3 (7994120775791599e205a5524ec3e0dfe41d4a06; 2015-04-22T11:57:37+00:00)
Maven home: /c/Users/nk/docker_stuff/tools/apache-maven-3.3.3
Java version: 1.7.0_79, vendor: Oracle Corporation
Java home: /c/Users/nk/docker_stuff/tools/jdk1.7.0_79/jre
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "4.0.9-boot2docker", arch: "amd64", family: "unix"

# build the package
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container/javaee6angularjsmysql$ pwd
/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container/javaee6angularjsmysql
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container/javaee6angularjsmysql$ mvn clean package

#check the parameters for database in persistence.xml
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container/javaee6angularjsmysql/src/main/resources/META-INF$ pwd
/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container/javaee6angularjsmysql/src/main/resources/META-INF
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container/javaee6angularjsmysql/src/main/resources/META-INF$ cat persistence.xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence
    version="2.1"
    xmlns="http://xmlns.jcp.org/xml/ns/persistence"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd">
    <persistence-unit name="MyPU" transaction-type="JTA">
        <jta-data-source>java:jboss/datasources/MySQLSampleDS</jta-data-source>
        <properties>
            <property name="javax.persistence.schema-generation.database.action" value="drop-and-create"/>
            <property name="javax.persistence.schema-generation.create-source" value="metadata"/>
            <property name="javax.persistence.schema-generation.drop-source" value="metadata"/>
            <property name="javax.persistence.sql-load-script-source" value="import.sql"/>
            <property name="hibernate.show_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>

# validate the connection parameters for mysql database
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container$ pwd
docker@default:/c/Users/nk/docker_stuff/projects/java_db/java/docker_mysql_container$ cat mysql-sample-ds.xml
<?xml version="1.0" encoding="UTF-8"?>
 <datasources>
   <datasource jndi-name="java:jboss/datasources/MySQLSampleDS" enabled="true" use-java-context="true"
         pool-name="MySQLSampleDS">
     <connection-url>jdbc:mysql://mydatabaseserver:3306/javadb</connection-url>
     <driver>mysql-connector-java-5.1.31-bin.jar_com.mysql.jdbc.Driver_5_1</driver>
     <security>
       <user-name>mysql</user-name>
       <password>mysql</password>
     </security>
   </datasource>
 </datasources>

# copy standalone.xml & dockerfile to build the image
d build --tag=java_db .

# run the app container by linking to mysql database
d run -it -p 8080:8080 --name=java_db_demo --link mysql_db:mydatabaseserver java_db

# to enable the jboss admin console
d run -it -p 8080:8080 -p 9990:9990 --link mysqldb:mydatabaseserver mysqlapp

