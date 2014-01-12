#!/bin/sh

PROJECT_NAME="beaglebone-pru"
VERSION=1.0.0-SNAPSHOT
JAVAC=$JAVA_HOME/bin/javac
JAR=$JAVA_HOME/bin/jar
JAVAH=$JAVA_HOME/bin/javah
INCLUDE=$JAVA_HOME/include
ARCH=$(uname -s|tr A-Z a-z)
LIBRARY_NAME="PRU"
# CLASSNAME=""
D=`pwd`
APP_LOADER=$D/"am335x_pru_package/pru_sw/app_loader/"
JAR_DIR="jar-files"

rm $APP_LOADER"interface/"prussdrv.o
cd $APP_LOADER"interface/"
gcc -I. -Wall -I$APP_LOADER"include/"  -c -fPIC -mtune=cortex-a8 -march=armv7-a -shared -o prussdrv.o prussdrv.c

cd $D

cd c/
rm lib$LIBRARY_NAME".so"

gcc -I. -Wall -I$APP_LOADER"include/" -I$INCLUDE -I$INCLUDE/linux -c -fPIC -mtune=cortex-a8 -march=armv7-a -shared -o pru_wrap.o pru_wrap.c

gcc -shared -o lib$LIBRARY_NAME".so" $APP_LOADER"interface/"prussdrv.o pru_wrap.o

cd $D

# compile java files
rm -rf $JAR_DIR
mkdir $JAR_DIR
find $PWD/ -type f -name \*.java | xargs $JAVAC -sourcepath java -d $JAR_DIR
cp c/lib$LIBRARY_NAME".so" $JAR_DIR

# # generate jni header
# #$JAVAH -jni -classpath . -o ${LIBRARY_NAME}.h $CLASSNAME

# # compile jni code
# cc -shared -I$INCLUDE -I$INCLUDE/$ARCH/ ${LIBRARY_NAME}.c -o "lib"${LIBRARY_NAME}".so" 

# generate pom
cat > pom.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>$PROJECT_NAME</groupId>
   <artifactId>$PROJECT_NAME</artifactId>
  <version>$VERSION</version>
  <name>$PROJECT_NAME</name>
</project>

EOF
 
# jar it all up
$JAR -cvf $PROJECT_NAME-$VERSION.jar -C $JAR_DIR .


