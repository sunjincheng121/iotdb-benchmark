#!/bin/sh

#组实验配置文件名,文件中一行对应一次实验的一个变化参数如LOOP=10,注意等号两边不能有空格
FILENAME=routine
IOTDB_CONF=$1
IS_TEST_BASELINE=$2
BRANCH=$3
MAVEN_CLEAN_REPO_PATH=$4

if [ -z "${BENCHMARK_HOME}" ]; then
  BENCHMARK_HOME="$(cd "`dirname "$0"`"/.; pwd)"
  export BENCHMARK_HOME="$(cd $BENCHMARK_HOME/..; pwd)"
fi
DB=$(grep "DB_SWITCH" $BENCHMARK_HOME/conf/config.properties)
BENCHMARK_WORK_MODE=$(grep "BENCHMARK_WORK_MODE" $BENCHMARK_HOME/conf/config.properties)
#cat $BENCHMARK_HOME/$FILENAME | while read LINE
FILE=$(cat $BENCHMARK_HOME/$FILENAME)
#echo $FILE
#实际上LINE是以换行或空格为分隔符
for LINE in $FILE;
do
  CHANGE_PARAMETER=$(echo $LINE | cut -d = -f 1)
  #CHANGE_LINE=$(grep -n  $CHANGE_PARAMETER $BENCHMARK_HOME/conf/config.properties | cut -d : -f 1)
  #sed -i "${CHANGE_LINE}s/^.*$/${LINE}/" $BENCHMARK_HOME/conf/config.properties
  if [ -n "$LINE" ]; then
    if [ "$LINE" != "TEST" ]; then
        sed -i "s/^${CHANGE_PARAMETER}.*$/${LINE}/g" $BENCHMARK_HOME/conf/config.properties
        grep $CHANGE_PARAMETER  $BENCHMARK_HOME/conf/config.properties
    else
        if [ "${DB#*=}" = "IoTDB" -a "${BENCHMARK_WORK_MODE#*=}" = "insertTestWithDefaultPath" ]; then
#            if [ $IS_TEST_BASELINE = "true" ]; then
#                sh $BENCHMARK_HOME/benchmark.sh
#            else
                sh $BENCHMARK_HOME/ciscripts/compare-branch.sh $IOTDB_CONF $IS_TEST_BASELINE $BRANCH $MAVEN_CLEAN_REPO_PATH
#            fi
        else
            sh $BENCHMARK_HOME/benchmark.sh $IS_TEST_BASELINE
        fi
    fi
  fi
done




#for i in {1..5}
#do
#  sh cli-benchmark.sh
#done
